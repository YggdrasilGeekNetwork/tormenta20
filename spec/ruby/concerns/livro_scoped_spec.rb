# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Concerns::LivroScoped do
  # Sample a few unrelated models to prove the concern applies generically
  # via Base, not per-model wiring.
  MODELS = [
    Tormenta20::Models::Classe,
    Tormenta20::Models::Poder,
    Tormenta20::Models::Ameaca,
    Tormenta20::Models::Encantamento
  ].freeze

  describe "livro_id column" do
    it "every record's livro_id resolves to a registered Livro" do
      livro_ids = Tormenta20::Models::Livro.pluck(:id)
      MODELS.each do |model|
        model.find_each { |record| expect(livro_ids).to include(record.livro_id) }
      end
    end
  end

  describe ".do_livro scope" do
    it "filters records by livro_id, partitioning the table exactly" do
      MODELS.each do |model|
        by_book = model.group(:livro_id).count
        by_book.each { |livro_id, n| expect(model.do_livro(livro_id).count).to eq(n) }
        expect(by_book.values.sum).to eq(model.count)
        expect(model.do_livro("nonexistent_book").count).to eq(0)
      end
    end
  end

  describe "#livro association" do
    it "resolves to the matching Livro record" do
      classe = Tormenta20::Models::Classe.first
      expect(classe.livro).to be_a(Tormenta20::Models::Livro)
      expect(classe.livro.id).to eq("t20_eja")
      expect(classe.livro.nome_curto).to eq("T20 - EJA")
    end
  end
end
