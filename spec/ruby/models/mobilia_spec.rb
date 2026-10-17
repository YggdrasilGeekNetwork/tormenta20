# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Mobilia do
  describe "table" do
    it "uses the mobilias table" do
      expect(described_class.table_name).to eq("mobilias")
    end
  end

  describe "data integrity" do
    it "has the 25 mobílias loaded" do
      expect(described_class.count).to eq(25)
    end

    it "each mobília has id, name, description and non-empty effects" do
      described_class.find_each do |m|
        expect(m.id).to be_present
        expect(m.name).to be_present
        expect(m.description).to be_present
        expect(m.effects).to be_an(Array)
        expect(m.effects).not_to be_empty
      end
    end
  end

  describe "instance methods" do
    let(:mobilia) do
      described_class.new(
        id: "bar", name: "Bar",
        description: "Um balcão com bancos altos. Fornece +1 PM para os residentes.",
        effects: [{ "type" => "bonus_pm", "value" => 1 }],
        preco: 1000,
        comodo_alvo: nil
      )
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = mobilia.to_h
        expect(hash[:id]).to eq("bar")
        expect(hash[:preco]).to eq(1000)
        expect(hash[:effects]).to be_an(Array)
      end
    end

    it "supports a comodo_alvo restriction" do
      banheira = described_class.new(id: "banheira", name: "Banheira", preco: 300, comodo_alvo: "suite")
      expect(banheira.comodo_alvo).to eq("suite")
    end
  end
end
