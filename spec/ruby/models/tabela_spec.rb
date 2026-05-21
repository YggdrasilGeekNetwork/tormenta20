# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Tabela do
  describe "table" do
    it "uses the tabelas table" do
      expect(described_class.table_name).to eq("tabelas")
    end
  end

  describe "validations" do
    it "requires id" do
      tabela = described_class.new(name: "Test")
      expect(tabela).not_to be_valid
      expect(tabela.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      tabela = described_class.new(id: "test")
      expect(tabela).not_to be_valid
      expect(tabela.errors[:name]).to include("can't be blank")
    end
  end

  describe "data integrity" do
    it "has tabelas loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "jogatina_resultados is present" do
      tabela = described_class.find("jogatina_resultados")
      expect(tabela).not_to be_nil
      expect(tabela.name).to eq("Resultados de Jogatina")
    end
  end

  describe "instance methods" do
    let(:jogatina_resultados) { described_class.find("jogatina_resultados") }

    describe "#to_h" do
      it "returns a hash with headers and rows" do
        hash = jogatina_resultados.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq("jogatina_resultados")
        expect(hash[:headers]).to be_an(Array)
        expect(hash[:headers]).to eq(%w[Teste Ganho])
        expect(hash[:rows]).to be_an(Array)
        expect(hash[:rows].size).to eq(6)
      end
    end

    describe "#headers" do
      it "returns column header labels" do
        expect(jogatina_resultados.headers).to include("Teste", "Ganho")
      end
    end

    describe "#rows" do
      it "returns row data keyed by header" do
        first_row = jogatina_resultados.rows.first
        expect(first_row["Teste"]).to eq("9 ou menos")
        expect(first_row["Ganho"]).to eq("Nenhum")
      end
    end
  end
end
