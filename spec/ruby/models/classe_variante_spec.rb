# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::ClasseVariante do
  describe "table" do
    it "uses the classes_variantes table" do
      expect(described_class.table_name).to eq("classes_variantes")
    end
  end

  describe "data integrity" do
    it "has classes_variantes loaded" do
      expect(described_class.count).to be_positive
    end

    it "each variant has id, name, base_class_id and a non-empty diffs array" do
      described_class.find_each do |v|
        expect(v.id).to be_present
        expect(v.name).to be_present
        expect(v.base_class_id).to be_present
        expect(v.diffs).to be_an(Array)
        expect(v.diffs).not_to be_empty
      end
    end
  end

  describe "#base_classe" do
    it "resolves to the base Classe record" do
      duelista = described_class.find("duelista")
      expect(duelista.base_classe).to be_a(Tormenta20::Models::Classe)
      expect(duelista.base_classe.id).to eq("bucaneiro")
    end
  end

  describe ".by_base" do
    it "returns only variants built on the given base class" do
      described_class.by_base("bucaneiro").each { |v| expect(v.base_class_id).to eq("bucaneiro") }
    end
  end

  it "each diff entry has nivel, remove and adiciona keys" do
    duelista = described_class.find("duelista")
    duelista.diffs.each do |diff|
      expect(diff).to have_key("nivel")
      expect(diff).to have_key("remove")
      expect(diff).to have_key("adiciona")
    end
  end
end
