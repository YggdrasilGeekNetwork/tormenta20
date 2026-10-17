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
        expect(%w[arma armadura esoterico acessorio]).to include(e.categoria)
      end
    end

    it "each encantamento has a non-empty effects array of typed objects" do
      described_class.find_each do |e|
        expect(e.effects).to be_an(Array)
        expect(e.effects).not_to be_empty
        e.effects.each { |effect| expect(effect["type"]).to be_a(String) }
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

    describe ".maldicoes" do
      it "returns only cursed enchantments" do
        described_class.maldicoes.each { |e| expect(e.maldicao).to be_in([true, 1]) }
      end
    end

    describe ".nao_maldicoes" do
      it "excludes cursed enchantments" do
        described_class.nao_maldicoes.each { |e| expect(e.maldicao).to be_in([false, nil, 0]) }
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
        expect([true, false]).to include(hash[:maldicao])
      end
    end
  end
end
