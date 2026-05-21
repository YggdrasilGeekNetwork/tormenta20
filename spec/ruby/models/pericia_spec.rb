# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Pericia do
  describe "table" do
    it "uses the pericias table" do
      expect(described_class.table_name).to eq("pericias")
    end
  end

  describe "validations" do
    it "requires id" do
      pericia = described_class.new(name: "Test", atributo: "FOR")
      expect(pericia).not_to be_valid
      expect(pericia.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      pericia = described_class.new(id: "test", atributo: "FOR")
      expect(pericia).not_to be_valid
      expect(pericia.errors[:name]).to include("can't be blank")
    end

    it "requires a valid atributo" do
      pericia = described_class.new(id: "test", name: "Test", atributo: "XYZ")
      expect(pericia).not_to be_valid
      expect(pericia.errors[:atributo]).to be_present
    end

    it "accepts all valid atributos" do
      %w[FOR DES CON INT SAB CAR].each do |attr|
        pericia = described_class.new(id: "test_#{attr.downcase}", name: "Test", atributo: attr)
        pericia.valid?
        expect(pericia.errors[:atributo]).to be_empty
      end
    end
  end

  describe "data integrity" do
    it "has all 29 pericias loaded from JSON" do
      expect(described_class.count).to eq(29)
    end

    it "each pericia has required fields" do
      described_class.find_each do |pericia|
        expect(pericia.id).to be_present
        expect(pericia.name).to be_present
        expect(pericia.atributo).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".by_atributo" do
      it "filters by atributo" do
        des_skills = described_class.by_atributo("DES")
        expect(des_skills.count).to be_positive
        des_skills.each { |p| expect(p.atributo).to eq("DES") }
      end
    end

    describe ".trained_only" do
      it "returns only trained-only skills" do
        described_class.trained_only.each do |p|
          expect([true, 1]).to include(p.trained_only)
        end
      end
    end

    describe ".with_armor_penalty" do
      it "returns skills with armor penalty" do
        ids = described_class.with_armor_penalty.pluck(:id)
        expect(ids).to include("acrobacia", "furtividade", "ladinagem")
      end
    end

    describe ".resistance_skills" do
      it "returns exactly fortitude, reflexos and vontade" do
        ids = described_class.resistance_skills.pluck(:id).sort
        expect(ids).to eq(%w[fortitude reflexos vontade])
      end
    end
  end

  describe "instance methods" do
    let(:acrobacia) { described_class.find("acrobacia") }
    let(:fortitude) { described_class.find("fortitude") }

    describe "#to_h" do
      it "returns a hash with all fields" do
        hash = acrobacia.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq("acrobacia")
        expect(hash[:name]).to eq("Acrobacia")
        expect(hash[:atributo]).to eq("DES")
        expect(hash[:trained_only]).to eq(false)
        expect(hash[:armor_penalty]).to eq(true)
        expect(hash[:resistance_skill]).to eq(false)
        expect(hash[:uses]).to be_an(Array)
      end
    end

    describe "#to_h resistance_skill" do
      it "is true for resistance skills" do
        expect(fortitude.to_h[:resistance_skill]).to be true
      end

      it "is false for non-resistance skills" do
        expect(acrobacia.to_h[:resistance_skill]).to be false
      end
    end

    describe "#uses" do
      it "returns an array for skills with named uses" do
        expect(acrobacia.uses).to be_an(Array)
        expect(acrobacia.uses).not_to be_empty
      end

      it "returns an array for skills without uses" do
        expect(fortitude.uses).to be_an(Array)
        expect(fortitude.uses).to be_empty
      end

      it "each use has name and description" do
        acrobacia.uses.each do |use|
          expect(use["name"]).to be_present
          expect(use["description"]).to be_present
        end
      end
    end
  end
end
