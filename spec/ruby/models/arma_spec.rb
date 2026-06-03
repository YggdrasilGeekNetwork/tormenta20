# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Arma do
  describe "table" do
    it "uses the armas table" do
      expect(described_class.table_name).to eq("armas")
    end
  end

  describe "validations" do
    it "requires id" do
      arma = described_class.new(name: "Test", category: "simples")
      expect(arma).not_to be_valid
      expect(arma.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      arma = described_class.new(id: "test", category: "simples")
      expect(arma).not_to be_valid
      expect(arma.errors[:name]).to include("can't be blank")
    end

    it "requires valid category" do
      arma = described_class.new(id: "test", name: "Test", category: "invalid")
      expect(arma).not_to be_valid
    end

    it "accepts valid categories" do
      %w[simples marciais exoticas fogo].each do |cat|
        arma = described_class.new(id: "test-#{cat}", name: "Test", category: cat)
        arma.valid?
        expect(arma.errors[:category]).to be_empty
      end
    end
  end

  describe "data integrity" do
    it "has armas loaded from JSON" do
      expect(described_class.count).to be_positive
    end

    it "each arma has required fields" do
      described_class.find_each do |arma|
        expect(arma.id).to be_present
        expect(arma.name).to be_present
        expect(arma.category).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".simples" do
      it "returns only simples weapons" do
        described_class.simples.each { |a| expect(a.category).to eq("simples") }
      end
    end

    describe ".marciais" do
      it "returns only marciais weapons" do
        described_class.marciais.each { |a| expect(a.category).to eq("marciais") }
      end
    end

    describe ".melee" do
      it "returns weapons with no range" do
        described_class.melee.each { |a| expect(a.range).to be_nil }
      end
    end

    describe ".ranged" do
      it "returns weapons with a range" do
        described_class.ranged.each { |a| expect(a.range).not_to be_nil }
      end
    end
  end

  describe "instance methods" do
    let(:arma) { described_class.find_by(id: "espada_longa") }

    describe "#ranged?" do
      it "returns false for melee weapons" do
        expect(arma.ranged?).to be false
      end
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = arma.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(arma.id)
        expect(hash[:name]).to eq(arma.name)
        expect(hash[:damage]).to eq(arma.damage)
        expect(hash[:critical]).to eq(arma.critical)
      end
    end
  end
end
