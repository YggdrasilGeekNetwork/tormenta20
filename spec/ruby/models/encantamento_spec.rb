# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Encantamento do
  describe "table" do
    it "uses the encantamentos table" do
      expect(described_class.table_name).to eq("encantamentos")
    end
  end

  describe "data integrity" do
    it "has encantamentos loaded from JSON" do
      expect(described_class.count).to be_positive
    end

    it "each encantamento has id, name, and valid categoria" do
      described_class.find_each do |e|
        expect(e.id).to be_present
        expect(e.name).to be_present
        expect(%w[arma armadura]).to include(e.categoria)
      end
    end
  end

  describe "scopes" do
    describe ".armas" do
      it "returns only arma enchantments" do
        described_class.armas.each { |e| expect(e.categoria).to eq("arma") }
      end
    end

    describe ".armaduras_escudos" do
      it "returns only armadura enchantments" do
        described_class.armaduras_escudos.each { |e| expect(e.categoria).to eq("armadura") }
      end
    end

    describe ".escudo_only" do
      it "returns only shield-exclusive enchantments" do
        described_class.escudo_only.each { |e| expect(e.escudo_only).to be_in([true, 1]) }
      end
    end
  end

  describe "instance methods" do
    let(:enc) { described_class.first }

    describe "#to_h" do
      it "coerces boolean fields" do
        hash = enc.to_h
        expect([true, false]).to include(hash[:escudo_only])
        expect([true, false]).to include(hash[:conta_como_dois])
      end
    end
  end
end
