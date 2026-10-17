# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Complicacao do
  describe "table" do
    it "uses the complicacoes table" do
      expect(described_class.table_name).to eq("complicacoes")
    end
  end

  describe "validations" do
    it "requires id" do
      complicacao = described_class.new(name: "Test", categoria: "geral")
      expect(complicacao).not_to be_valid
      expect(complicacao.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      complicacao = described_class.new(id: "test", categoria: "geral")
      expect(complicacao).not_to be_valid
      expect(complicacao.errors[:name]).to include("can't be blank")
    end
  end

  describe "data integrity" do
    it "has complicações loaded" do
      expect(described_class.count).to be_positive
    end

    it "each complicação has id, name, categoria and non-empty effects" do
      described_class.find_each do |c|
        expect(c.id).to be_present
        expect(c.name).to be_present
        expect(c.categoria).to be_present
        expect(c.effects).to be_an(Array)
        expect(c.effects).not_to be_empty
      end
    end

    it "has 32 gerais and the rest split across classes" do
      expect(described_class.gerais.count).to eq(32)
      expect(described_class.where.not(categoria: "geral").count).to be_positive
    end
  end

  describe "scopes" do
    describe ".gerais" do
      it "returns only categoria geral" do
        described_class.gerais.each { |c| expect(c.categoria).to eq("geral") }
      end
    end

    describe ".by_categoria" do
      it "filters by the given categoria" do
        described_class.by_categoria("guerreiro").each { |c| expect(c.categoria).to eq("guerreiro") }
      end
    end
  end

  describe "instance methods" do
    let(:complicacao) do
      described_class.new(
        id: "teste_complicacao", name: "Complicação de Teste", categoria: "geral",
        description: "Uma complicação de teste.",
        effects: [{ "type" => "penalidade_pericia", "pericia" => "furtividade", "value" => -2 }]
      )
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = complicacao.to_h
        expect(hash[:id]).to eq("teste_complicacao")
        expect(hash[:categoria]).to eq("geral")
        expect(hash[:effects]).to eq([{ "type" => "penalidade_pericia", "pericia" => "furtividade", "value" => -2 }])
      end
    end
  end
end
