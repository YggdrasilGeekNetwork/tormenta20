# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::MaterialEspecial do
  describe "table" do
    it "uses the materiais_especiais table" do
      expect(described_class.table_name).to eq("materiais_especiais")
    end
  end

  describe "validations" do
    it "requires id" do
      material = described_class.new(name: "Test")
      expect(material).not_to be_valid
      expect(material.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      material = described_class.new(id: "test")
      expect(material).not_to be_valid
      expect(material.errors[:name]).to include("can't be blank")
    end
  end

  describe "data integrity" do
    it "has materiais_especiais loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each material has required fields" do
      described_class.find_each do |material|
        expect(material.id).to be_present
        expect(material.name).to be_present
      end
    end
  end

  describe "instance methods" do
    let(:material) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = material.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(material.id)
        expect(hash[:name]).to eq(material.name)
      end
    end
  end
end
