# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::ConstrucaoDominio do
  describe "table" do
    it "uses the construcoes_dominio table" do
      expect(described_class.table_name).to eq("construcoes_dominio")
    end
  end

  describe "scopes" do
    describe ".by_categoria" do
      it "filters by the given categoria" do
        expect(described_class.by_categoria("religiao").to_sql).to include("religiao")
      end
    end
  end

  describe "instance methods" do
    let(:construcao) do
      described_class.new(
        id: "biblioteca_dominio", name: "Biblioteca", categoria: "nobreza",
        description: "Com uma coleção de pergaminhos, livros e tomos variados, este lugar tem muito a ensinar. Você se torna treinado em uma perícia.",
        custo: 10, effects: [{ "type" => "pericia_treinada", "value" => 1 }], prerequisito: nil
      )
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = construcao.to_h
        expect(hash[:id]).to eq("biblioteca_dominio")
        expect(hash[:categoria]).to eq("nobreza")
        expect(hash[:custo]).to eq(10)
        expect(hash[:effects]).to be_an(Array)
      end
    end

    it "supports a prerequisito" do
      castelo = described_class.new(id: "castelo", name: "Castelo", categoria: "nobreza", prerequisito: "forte")
      expect(castelo.prerequisito).to eq("forte")
    end
  end
end
