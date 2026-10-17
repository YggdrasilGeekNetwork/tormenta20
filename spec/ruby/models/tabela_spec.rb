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
      expect(described_class.count).to be_positive
    end

    it "jogatina_resultados is present" do
      tabela = described_class.find("jogatina_resultados")
      expect(tabela).not_to be_nil
      expect(tabela.name).to eq("Resultados de Jogatina")
    end

    it "every tabela has non-empty headers and rows" do
      described_class.find_each do |tabela|
        expect(tabela.headers).to be_an(Array)
        expect(tabela.headers).not_to be_empty
        expect(tabela.rows).to be_an(Array)
        expect(tabela.rows).not_to be_empty
      end
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

  describe "sorteio (#roll)" do
    let(:rollable) do
      described_class.new(
        id: "teste_sorteio",
        name: "Teste de Sorteio",
        headers: %w[Faixa Resultado],
        rows: [
          { "Faixa" => "01-50", "Resultado" => "A" },
          { "Faixa" => "51-100", "Resultado" => "B" }
        ],
        dice: "1d100"
      )
    end

    let(:non_rollable) { described_class.new(id: "sem_dado", name: "Sem Dado", headers: ["X"], rows: [{ "X" => "1" }]) }

    describe "#sorteavel?" do
      it "is true when dice is present" do
        expect(rollable.sorteavel?).to be true
      end

      it "is false when dice is absent" do
        expect(non_rollable.sorteavel?).to be false
      end
    end

    describe "#roll" do
      it "raises when the table has no dice column" do
        expect { non_rollable.roll }.to raise_error(/não é sorteável/)
      end

      it "returns the row whose range contains the roll" do
        allow(rollable).to receive(:rand).and_return(37)
        expect(rollable.roll).to eq({ "Faixa" => "01-50", "Resultado" => "A" })

        allow(rollable).to receive(:rand).and_return(75)
        expect(rollable.roll).to eq({ "Faixa" => "51-100", "Resultado" => "B" })
      end

      it "always returns a row matching a valid dice range over many rolls" do
        100.times { expect(rollable.roll).not_to be_nil }
      end
    end

    describe ".in_range?" do
      it "matches a range string" do
        expect(described_class.in_range?("01-05", 3)).to be true
        expect(described_class.in_range?("01-05", 6)).to be false
      end

      it "matches a single value" do
        expect(described_class.in_range?("07", 7)).to be true
        expect(described_class.in_range?("07", 8)).to be false
      end
    end
  end
end
