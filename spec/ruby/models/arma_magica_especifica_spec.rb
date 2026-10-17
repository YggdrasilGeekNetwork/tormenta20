# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::ArmaMagicaEspecifica do
  describe "table" do
    it "uses the armas_magicas_especificas table" do
      expect(described_class.table_name).to eq("armas_magicas_especificas")
    end
  end

  describe "data integrity" do
    it "has armas magicas especificas loaded" do
      expect(described_class.count).to be_positive
    end

    it "each arma has id, name and base_weapon" do
      described_class.find_each do |a|
        expect(a.id).to be_present
        expect(a.name).to be_present
        expect(a.base_weapon).to be_present
      end
    end

    it "each arma has a non-empty effects array of typed objects" do
      described_class.find_each do |a|
        expect(a.effects).to be_an(Array)
        expect(a.effects).not_to be_empty
        a.effects.each { |effect| expect(effect["type"]).to be_a(String) }
      end
    end
  end

  describe ".by_base" do
    it "returns only armas built on the given base weapon" do
      arma = described_class.first
      described_class.by_base(arma.base_weapon).each { |a| expect(a.base_weapon).to eq(arma.base_weapon) }
    end
  end

  describe "instance methods" do
    let(:arma) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = arma.to_h
        expect(hash[:id]).to eq(arma.id)
        expect(hash[:effects]).to be_an(Array)
      end
    end
  end
end
