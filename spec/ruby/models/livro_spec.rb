# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Livro do
  describe "table" do
    it "uses the livros table" do
      expect(described_class.table_name).to eq("livros")
    end
  end

  describe "data integrity" do
    it "has livros loaded" do
      expect(described_class.count).to be > 0
    end

    it "each livro has nome and nome_curto" do
      described_class.find_each do |l|
        expect(l.nome).to be_present
        expect(l.nome_curto).to be_present
      end
    end
  end

  describe "instance methods" do
    let(:livro) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = livro.to_h
        expect(hash[:nome]).to eq(livro.nome)
        expect(hash[:nome_curto]).to eq(livro.nome_curto)
      end
    end
  end
end
