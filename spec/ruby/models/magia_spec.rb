# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Magia do
  describe "table" do
    it "uses the magias table" do
      expect(described_class.table_name).to eq("magias")
    end
  end

  describe "validations" do
    let(:valid_attributes) do
      {
        id: "test-magia",
        name: "Test Magia",
        type: "arcana",
        circle: "1",
        school: "evoc",
        execution: "padrão",
        range: "curto",
        duration: "instantânea",
        description: "Test description"
      }
    end

    it "requires id" do
      magia = described_class.new(valid_attributes.except(:id))
      expect(magia).not_to be_valid
      expect(magia.errors[:id]).to include("can't be blank")
    end

    it "requires name" do
      magia = described_class.new(valid_attributes.except(:name))
      expect(magia).not_to be_valid
      expect(magia.errors[:name]).to include("can't be blank")
    end

    it "requires valid type" do
      magia = described_class.new(valid_attributes.merge(type: "invalid"))
      expect(magia).not_to be_valid
      expect(magia.errors[:type]).to include("is not included in the list")
    end

    it "accepts valid types" do
      %w[arcana divina universal].each do |type|
        magia = described_class.new(valid_attributes.merge(type: type))
        magia.valid?
        expect(magia.errors[:type]).to be_empty
      end
    end

    it "requires valid school" do
      magia = described_class.new(valid_attributes.merge(school: "invalid"))
      expect(magia).not_to be_valid
      expect(magia.errors[:school]).to include("is not included in the list")
    end

    it "accepts valid schools" do
      %w[abjur adiv conv encan evoc ilus necro trans].each do |school|
        magia = described_class.new(valid_attributes.merge(school: school))
        magia.valid?
        expect(magia.errors[:school]).to be_empty
      end
    end
  end

  describe "data integrity" do
    it "has magias loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each magia has required fields" do
      described_class.find_each do |magia|
        expect(magia.id).to be_present
        expect(magia.name).to be_present
        expect(magia.type).to be_present
        expect(magia.school).to be_present
      end
    end

    it "all magias have valid types" do
      described_class.find_each do |magia|
        expect(%w[arcana divina universal]).to include(magia.type)
      end
    end

    it "all magias have valid schools" do
      valid_schools = %w[abjur adiv conv encan evoc ilus necro trans]
      described_class.find_each do |magia|
        expect(valid_schools).to include(magia.school)
      end
    end
  end

  describe "scopes" do
    describe ".arcanas" do
      it "returns only arcane spells" do
        described_class.arcanas.each do |magia|
          expect(magia.type).to eq("arcana")
        end
      end
    end

    describe ".divinas" do
      it "returns only divine spells" do
        described_class.divinas.each do |magia|
          expect(magia.type).to eq("divina")
        end
      end
    end

    describe ".universais" do
      it "returns only universal spells" do
        described_class.universais.each do |magia|
          expect(magia.type).to eq("universal")
        end
      end
    end

    describe ".by_circle" do
      it "filters by circle" do
        described_class.by_circle("1").each do |magia|
          expect(magia.circle).to eq("1")
        end
      end
    end

    describe ".by_school" do
      it "filters by school" do
        described_class.by_school("evoc").each do |magia|
          expect(magia.school).to eq("evoc")
        end
      end
    end
  end

  describe "class methods" do
    describe ".todas" do
      it "returns all spells" do
        expect(described_class.todas.count).to eq(described_class.count)
      end
    end

    describe ".divinas_list" do
      it "returns divine spells" do
        expect(described_class.divinas_list.to_a).to eq(described_class.divinas.to_a)
      end
    end

    describe ".arcanas_list" do
      it "returns arcane spells" do
        expect(described_class.arcanas_list.to_a).to eq(described_class.arcanas.to_a)
      end
    end

    describe ".do_circulo" do
      it "filters by circle" do
        expect(described_class.do_circulo("2").to_a).to eq(described_class.by_circle("2").to_a)
      end
    end

    describe ".da_escola" do
      it "filters by school" do
        expect(described_class.da_escola("necro").to_a).to eq(described_class.by_school("necro").to_a)
      end
    end
  end

  describe "instance methods" do
    let(:magia) { described_class.first }

    describe "#target_info" do
      it "returns target information as a hash" do
        info = magia.target_info
        expect(info).to be_a(Hash)
        expect(info).to have_key(:amount)
        expect(info).to have_key(:up_to)
        expect(info).to have_key(:type)
      end
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = magia.to_h
        expect(hash).to be_a(Hash)
        expect(hash[:id]).to eq(magia.id)
        expect(hash[:name]).to eq(magia.name)
        expect(hash[:type]).to eq(magia.type)
        expect(hash[:school]).to eq(magia.school)
      end
    end
  end
end
