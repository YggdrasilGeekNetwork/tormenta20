# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Origem do
  describe "table" do
    it "uses the origens table" do
      expect(described_class.table_name).to eq("origens")
    end
  end

  describe "validations" do
    it "requires id" do
      origem = described_class.new(name: "Test")
      expect(origem).not_to be_valid
      expect(origem.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      origem = described_class.new(id: "test")
      expect(origem).not_to be_valid
      expect(origem.errors[:name]).to include("can't be blank")
    end
  end

  describe "data integrity" do
    it "has origens loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each origem has required fields" do
      described_class.find_each do |origem|
        expect(origem.id).to be_present
        expect(origem.name).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".with_unique_power" do
      it "returns origens that have a unique power" do
        origens_with_power = described_class.with_unique_power
        origens_with_power.each do |origem|
          expect(origem.unique_power).not_to be_nil
        end
      end
    end
  end

  describe "instance methods" do
    let(:origem) { described_class.first }

    describe "#skills" do
      it "returns skills from benefits" do
        expect(origem.skills).to be_an(Array)
      end
    end

    describe "#powers" do
      it "returns powers from benefits" do
        expect(origem.powers).to be_an(Array)
      end
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = origem.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(origem.id)
        expect(hash[:name]).to eq(origem.name)
      end
    end
  end
end
