# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Condicao do
  describe "table" do
    it "uses the condicoes table" do
      expect(described_class.table_name).to eq("condicoes")
    end
  end

  describe "data integrity" do
    it "has condicoes loaded from JSON" do
      expect(described_class.count).to be_positive
    end

    it "each condicao has id and name" do
      described_class.find_each do |c|
        expect(c.id).to be_present
        expect(c.name).to be_present
      end
    end

    it "effects is always an array" do
      described_class.find_each do |c|
        expect(c.effects).to be_an(Array)
      end
    end
  end

  describe "scopes" do
    describe ".medo" do
      it "returns only medo type conditions" do
        described_class.medo.each { |c| expect(c.condition_type).to eq("medo") }
      end
    end

    describe ".mental" do
      it "returns only mental type conditions" do
        described_class.mental.each { |c| expect(c.condition_type).to eq("mental") }
      end
    end

    describe ".by_type" do
      it "filters by condition_type" do
        described_class.by_type("movimento").each { |c| expect(c.condition_type).to eq("movimento") }
      end
    end
  end

  describe "instance methods" do
    let(:condicao) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = condicao.to_h
        expect(hash[:id]).to eq(condicao.id)
        expect(hash[:name]).to eq(condicao.name)
        expect(hash[:effects]).to be_an(Array)
      end
    end
  end
end
