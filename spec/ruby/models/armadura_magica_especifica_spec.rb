# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::ArmaduraMagicaEspecifica do
  describe "table" do
    it "uses the armaduras_magicas_especificas table" do
      expect(described_class.table_name).to eq("armaduras_magicas_especificas")
    end
  end

  describe "data integrity" do
    it "has armaduras magicas especificas loaded" do
      expect(described_class.count).to be_positive
    end

    it "each armadura has id, name and valid subtipo" do
      described_class.find_each do |a|
        expect(a.id).to be_present
        expect(a.name).to be_present
        expect(%w[armadura escudo]).to include(a.subtipo)
      end
    end

    it "each armadura has a non-empty effects array of typed objects" do
      described_class.find_each do |a|
        expect(a.effects).to be_an(Array)
        expect(a.effects).not_to be_empty
        a.effects.each { |effect| expect(effect["type"]).to be_a(String) }
      end
    end
  end

  describe "scopes" do
    describe ".armaduras" do
      it "returns only subtipo armadura" do
        described_class.armaduras.each { |a| expect(a.subtipo).to eq("armadura") }
      end
    end

    describe ".escudos" do
      it "returns only subtipo escudo" do
        described_class.escudos.each { |a| expect(a.subtipo).to eq("escudo") }
      end
    end
  end

  describe "instance methods" do
    let(:armadura) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = armadura.to_h
        expect(hash[:id]).to eq(armadura.id)
        expect(hash[:effects]).to be_an(Array)
      end
    end
  end
end
