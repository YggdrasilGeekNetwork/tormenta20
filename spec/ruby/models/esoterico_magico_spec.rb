# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::EsotericoMagico do
  describe "table" do
    it "uses the esotericos_magicos table" do
      expect(described_class.table_name).to eq("esotericos_magicos")
    end
  end

  describe "data integrity" do
    it "has esotéricos específicos loaded" do
      expect(described_class.count).to be_positive
    end

    it "each esoterico has id, name, categoria and non-empty effects" do
      described_class.find_each do |e|
        expect(e.id).to be_present
        expect(e.name).to be_present
        expect(e.categoria).to be_present
        expect(e.effects).to be_an(Array)
        expect(e.effects).not_to be_empty
      end
    end
  end

  describe "scopes" do
    describe ".maiores" do
      it "returns only categoria maior" do
        described_class.maiores.each { |e| expect(e.categoria).to eq("maior") }
      end
    end

    describe ".medios" do
      it "returns only categoria medio" do
        described_class.medios.each { |e| expect(e.categoria).to eq("medio") }
      end
    end
  end

  describe "instance methods" do
    let(:esoterico) do
      described_class.new(
        id: "teste_esoterico", name: "Cajado de Teste", categoria: "maior",
        preco: 50_000, roll_min: 1, roll_max: 5,
        description: "Um cajado de teste.", effects: [{ "type" => "bonus_pm", "value" => 5 }]
      )
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = esoterico.to_h
        expect(hash[:id]).to eq("teste_esoterico")
        expect(hash[:categoria]).to eq("maior")
        expect(hash[:effects]).to eq([{ "type" => "bonus_pm", "value" => 5 }])
      end
    end

    describe "#attributes" do
      it "exposes id and categoria" do
        expect(esoterico.id).to be_present
        expect(esoterico.categoria).to be_present
      end
    end
  end
end
