# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::BaseTipo do
  describe "table" do
    it "uses the bases_tipos table" do
      expect(described_class.table_name).to eq("bases_tipos")
    end
  end

  describe "data integrity" do
    it "has the 6 base types loaded" do
      expect(described_class.count).to eq(6)
    end

    it "each tipo has id, name, description and non-empty effects" do
      described_class.find_each do |t|
        expect(t.id).to be_present
        expect(t.name).to be_present
        expect(t.description).to be_present
        expect(t.effects).to be_an(Array)
        expect(t.effects).not_to be_empty
      end
    end

    it "includes the 6 named types from the book" do
      ids = described_class.pluck(:id)
      expect(ids).to contain_exactly(
        "esconderijo", "fortificacao", "movel", "residencia", "centro_de_poder", "empreendimento"
      )
    end
  end

  describe "instance methods" do
    describe "#to_h" do
      it "returns a hash representation" do
        tipo = described_class.find("fortificacao")
        hash = tipo.to_h
        expect(hash[:id]).to eq("fortificacao")
        expect(hash[:effects]).to be_an(Array)
      end
    end
  end
end
