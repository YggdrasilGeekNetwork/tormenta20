# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Armadura do
  describe "table" do
    it "uses the armaduras table" do
      expect(described_class.table_name).to eq("armaduras")
    end
  end

  describe "validations" do
    it "requires id" do
      a = described_class.new(name: "Test", category: "leve", defense_bonus: 2)
      expect(a).not_to be_valid
      expect(a.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      a = described_class.new(id: "test", category: "leve", defense_bonus: 2)
      expect(a).not_to be_valid
    end

    it "requires valid category" do
      a = described_class.new(id: "test", name: "Test", category: "invalida", defense_bonus: 2)
      expect(a).not_to be_valid
    end
  end

  describe "data integrity" do
    it "has armaduras loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each armadura has a positive defense_bonus" do
      described_class.find_each do |a|
        expect(a.defense_bonus).to be > 0
      end
    end
  end

  describe "scopes" do
    describe ".leves" do
      it "returns only leve armaduras" do
        described_class.leves.each { |a| expect(a.category).to eq("leve") }
      end
    end

    describe ".pesadas" do
      it "returns only pesada armaduras" do
        described_class.pesadas.each { |a| expect(a.category).to eq("pesada") }
      end
    end
  end

  describe "instance methods" do
    let(:armadura) { described_class.find_by(id: "cota_de_malha") }

    describe "#leve?" do
      it "returns false for heavy armor" do
        expect(armadura.leve?).to be false
      end
    end

    describe "#pesada?" do
      it "returns true for heavy armor" do
        expect(armadura.pesada?).to be true
      end
    end

    describe "#to_h" do
      it "returns a hash with defense_bonus" do
        hash = armadura.to_h
        expect(hash[:defense_bonus]).to eq(armadura.defense_bonus)
      end
    end
  end
end
