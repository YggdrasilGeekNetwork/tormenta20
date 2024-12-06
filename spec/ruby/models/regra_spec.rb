# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Regra do
  describe "table" do
    it "uses the regras table" do
      expect(described_class.table_name).to eq("regras")
    end
  end

  describe "validations" do
    it "requires id" do
      regra = described_class.new(name: "Test", data: {})
      expect(regra).not_to be_valid
      expect(regra.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      regra = described_class.new(id: "test", data: {})
      expect(regra).not_to be_valid
      expect(regra.errors[:name]).to include("can't be blank")
    end

    it "requires data" do
      regra = described_class.new(id: "test", name: "Test")
      expect(regra).not_to be_valid
      expect(regra.errors[:data]).to include("can't be blank")
    end
  end

  describe "data integrity" do
    it "has regras loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each regra has required fields" do
      described_class.find_each do |regra|
        expect(regra.id).to be_present
        expect(regra.name).to be_present
        expect(regra.data).to be_present
      end
    end
  end

  describe "instance methods" do
    let(:regra) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = regra.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(regra.id)
        expect(hash[:name]).to eq(regra.name)
        expect(hash[:data]).to eq(regra.data)
      end
    end
  end
end
