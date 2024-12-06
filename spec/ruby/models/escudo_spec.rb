# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Escudo do
  describe "table" do
    it "uses the escudos table" do
      expect(described_class.table_name).to eq("escudos")
    end
  end

  describe "validations" do
    it "requires id" do
      escudo = described_class.new(name: "Test", defense_bonus: 1)
      expect(escudo).not_to be_valid
      expect(escudo.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      escudo = described_class.new(id: "test", defense_bonus: 1)
      expect(escudo).not_to be_valid
      expect(escudo.errors[:name]).to include("can't be blank")
    end

    it "requires defense_bonus" do
      escudo = described_class.new(id: "test", name: "Test")
      expect(escudo).not_to be_valid
      expect(escudo.errors[:defense_bonus]).to include("can't be blank")
    end
  end

  describe "data integrity" do
    it "has escudos loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each escudo has required fields" do
      described_class.find_each do |escudo|
        expect(escudo.id).to be_present
        expect(escudo.name).to be_present
        expect(escudo.defense_bonus).to be_present
      end
    end
  end

  describe "instance methods" do
    let(:escudo) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = escudo.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(escudo.id)
        expect(hash[:name]).to eq(escudo.name)
        expect(hash[:defense_bonus]).to eq(escudo.defense_bonus)
      end
    end
  end
end
