# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Divindade do
  describe "table" do
    it "uses the divindades table" do
      expect(described_class.table_name).to eq("divindades")
    end
  end

  describe "validations" do
    it "requires id" do
      divindade = described_class.new(name: "Test", energy: "positiva")
      expect(divindade).not_to be_valid
      expect(divindade.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      divindade = described_class.new(id: "test", energy: "positiva")
      expect(divindade).not_to be_valid
      expect(divindade.errors[:name]).to include("can't be blank")
    end

    it "requires valid energy" do
      divindade = described_class.new(id: "test", name: "Test", energy: "invalid")
      expect(divindade).not_to be_valid
      expect(divindade.errors[:energy]).to include("is not included in the list")
    end

    it "accepts valid energies" do
      described_class::ENERGIES.each do |energy|
        divindade = described_class.new(id: "test-#{energy}", name: "Test", energy: energy)
        divindade.valid?
        expect(divindade.errors[:energy]).to be_empty
      end
    end
  end

  describe "data integrity" do
    it "has divindades loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each divindade has required fields" do
      described_class.find_each do |divindade|
        expect(divindade.id).to be_present
        expect(divindade.name).to be_present
        expect(divindade.energy).to be_present
      end
    end

    it "all divindades have valid energies" do
      described_class.find_each do |divindade|
        expect(described_class::ENERGIES).to include(divindade.energy)
      end
    end
  end

  describe "scopes" do
    describe ".energia_positiva" do
      it "returns only divindades with positive energy" do
        described_class.energia_positiva.each do |divindade|
          expect(divindade.energy).to eq("positiva")
        end
      end
    end

    describe ".energia_negativa" do
      it "returns only divindades with negative energy" do
        described_class.energia_negativa.each do |divindade|
          expect(divindade.energy).to eq("negativa")
        end
      end
    end

    describe ".by_energy" do
      it "filters by energy type" do
        described_class.by_energy("positiva").each do |divindade|
          expect(divindade.energy).to eq("positiva")
        end
      end
    end
  end

  describe "instance methods" do
    let(:divindade) { described_class.first }

    describe "#races" do
      it "returns an array" do
        expect(divindade.races).to be_an(Array)
      end
    end

    describe "#classes" do
      it "returns an array" do
        expect(divindade.classes).to be_an(Array)
      end
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = divindade.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(divindade.id)
        expect(hash[:name]).to eq(divindade.name)
        expect(hash[:energy]).to eq(divindade.energy)
      end
    end
  end
end
