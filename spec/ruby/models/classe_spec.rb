# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Classe do
  describe "table" do
    it "uses the classes table" do
      expect(described_class.table_name).to eq("classes")
    end
  end

  describe "validations" do
    it "requires id" do
      classe = described_class.new(name: "Test")
      expect(classe).not_to be_valid
      expect(classe.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      classe = described_class.new(id: "test")
      expect(classe).not_to be_valid
      expect(classe.errors[:name]).to include("can't be blank")
    end
  end

  describe "data integrity" do
    it "has classes loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each class has required fields" do
      described_class.find_each do |classe|
        expect(classe.id).to be_present
        expect(classe.name).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".conjuradores" do
      it "returns only spellcasting classes" do
        described_class.conjuradores.each do |classe|
          expect(classe.spellcasting).not_to be_nil
        end
      end
    end
  end

  describe "instance methods" do
    let(:classe) { described_class.first }

    describe "#initial_hp" do
      it "returns a number" do
        expect(classe.initial_hp).to be_a(Integer)
      end
    end

    describe "#hp_per_level" do
      it "returns a number" do
        expect(classe.hp_per_level).to be_a(Integer)
      end
    end

    describe "#mp_per_level" do
      it "returns a number" do
        expect(classe.mp_per_level).to be_a(Integer)
      end
    end

    describe "#mandatory_skills" do
      it "returns an array" do
        expect(classe.mandatory_skills).to be_an(Array)
      end
    end

    describe "#available_skills" do
      it "returns an array" do
        expect(classe.available_skills).to be_an(Array)
      end
    end

    describe "#weapon_proficiencies" do
      it "returns an array" do
        expect(classe.weapon_proficiencies).to be_an(Array)
      end
    end

    describe "#armor_proficiencies" do
      it "returns an array" do
        expect(classe.armor_proficiencies).to be_an(Array)
      end
    end

    describe "#conjurador?" do
      it "returns a boolean" do
        expect([true, false]).to include(classe.conjurador?)
      end
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = classe.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(classe.id)
        expect(hash[:name]).to eq(classe.name)
      end
    end
  end
end
