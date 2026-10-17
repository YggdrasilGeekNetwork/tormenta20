# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Artefato do
  describe "table" do
    it "uses the artefatos table" do
      expect(described_class.table_name).to eq("artefatos")
    end
  end

  describe "data integrity" do
    it "has artefatos loaded" do
      expect(described_class.count).to be_positive
    end

    it "each artefato has id, name and description" do
      described_class.find_each do |a|
        expect(a.id).to be_present
        expect(a.name).to be_present
        expect(a.description).to be_present
      end
    end

    it "each artefato has a non-empty effects array of typed objects" do
      described_class.find_each do |a|
        expect(a.effects).to be_an(Array)
        expect(a.effects).not_to be_empty
        a.effects.each { |effect| expect(effect["type"]).to be_a(String) }
      end
    end
  end

  describe "instance methods" do
    let(:artefato) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = artefato.to_h
        expect(hash[:id]).to eq(artefato.id)
        expect(hash[:effects]).to be_an(Array)
      end
    end
  end

  it "finds a known artefato by id" do
    espada_deus = described_class.find_by(id: "espada_deus")
    expect(espada_deus).not_to be_nil
    expect(espada_deus.name).to eq("A Espada-Deus")
  end
end
