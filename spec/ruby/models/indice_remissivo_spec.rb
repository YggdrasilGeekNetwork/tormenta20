# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::IndiceRemissivo do
  describe "table" do
    it "uses the indice_remissivo table" do
      expect(described_class.table_name).to eq("indice_remissivo")
    end
  end

  describe "data integrity" do
    it "has entries loaded" do
      expect(described_class.count).to be > 0
    end

    it "each entry has termo and pagina" do
      described_class.find_each do |i|
        expect(i.termo).to be_present
        expect(i.pagina).to be > 0
      end
    end
  end

  describe "scopes" do
    describe ".associados" do
      it "returns only entries with registro_id" do
        described_class.associados.each { |i| expect(i.registro_id).to be_present }
      end
    end

    describe ".nao_associados" do
      it "returns only entries without registro_id" do
        described_class.nao_associados.each { |i| expect(i.registro_id).to be_nil }
      end
    end

    describe ".buscar_termo" do
      it "returns entries matching the query" do
        result = described_class.buscar_termo("espada")
        result.each { |i| expect(i.termo.downcase).to include("espada") }
      end
    end
  end

  describe "instance methods" do
    let(:entry) { described_class.first }

    describe "#associado?" do
      it "reflects presence of registro_id" do
        expect(entry.associado?).to eq(entry.registro_id.present?)
      end
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = entry.to_h
        expect(hash[:termo]).to eq(entry.termo)
        expect(hash[:pagina]).to eq(entry.pagina)
      end
    end
  end
end
