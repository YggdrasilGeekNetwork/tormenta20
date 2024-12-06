# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Poder do
  describe "table" do
    it "uses the poderes table" do
      expect(described_class.table_name).to eq("poderes")
    end
  end

  describe "validations" do
    it "requires id" do
      poder = described_class.new(name: "Test", type: "poder_concedido")
      expect(poder).not_to be_valid
      expect(poder.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      poder = described_class.new(id: "test", type: "poder_concedido")
      expect(poder).not_to be_valid
      expect(poder.errors[:name]).to include("can't be blank")
    end

    it "requires valid type" do
      poder = described_class.new(id: "test", name: "Test", type: "invalid_type")
      expect(poder).not_to be_valid
      expect(poder.errors[:type]).to include("is not included in the list")
    end

    it "accepts valid types" do
      described_class::TYPES.each do |type|
        poder = described_class.new(id: "test-#{type}", name: "Test", type: type)
        poder.valid?
        expect(poder.errors[:type]).to be_empty
      end
    end
  end

  describe "data integrity" do
    it "has poderes loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each poder has required fields" do
      described_class.find_each do |poder|
        expect(poder.id).to be_present
        expect(poder.name).to be_present
        expect(poder.type).to be_present
      end
    end

    it "all poderes have valid types" do
      described_class.find_each do |poder|
        expect(described_class::TYPES).to include(poder.type)
      end
    end
  end

  describe "scopes" do
    describe ".habilidades_unicas" do
      it "returns only habilidade_unica_origem type" do
        described_class.habilidades_unicas.each do |poder|
          expect(poder.type).to eq("habilidade_unica_origem")
        end
      end
    end

    describe ".poderes_concedidos" do
      it "returns only poder_concedido type" do
        described_class.poderes_concedidos.each do |poder|
          expect(poder.type).to eq("poder_concedido")
        end
      end
    end

    describe ".poderes_tormenta" do
      it "returns only poder_tormenta type" do
        described_class.poderes_tormenta.each do |poder|
          expect(poder.type).to eq("poder_tormenta")
        end
      end
    end

    describe ".by_type" do
      it "filters by type" do
        type = "poder_concedido"
        described_class.by_type(type).each do |poder|
          expect(poder.type).to eq(type)
        end
      end
    end
  end

  describe "instance methods" do
    let(:poder) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = poder.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(poder.id)
        expect(hash[:name]).to eq(poder.name)
        expect(hash[:type]).to eq(poder.type)
      end
    end
  end
end
