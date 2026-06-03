# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Pocao do
  describe "table" do
    it "uses the pocoes table" do
      expect(described_class.table_name).to eq("pocoes")
    end
  end

  describe "data integrity" do
    it "has pocoes loaded from JSON" do
      expect(described_class.count).to be_positive
    end

    it "each pocao has id, name, and subtipo" do
      described_class.find_each do |p|
        expect(p.id).to be_present
        expect(p.name).to be_present
        expect(p.subtipo).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".menores" do
      it "returns only menor category" do
        described_class.menores.each { |p| expect(p.categoria).to eq("menor") }
      end
    end

    describe ".pocoes" do
      it "returns only pocao subtipo" do
        described_class.pocoes.each { |p| expect(p.subtipo).to eq("pocao") }
      end
    end

    describe ".oleos" do
      it "returns only oleo subtipo" do
        described_class.oleos.each { |p| expect(p.subtipo).to eq("oleo") }
      end
    end
  end

  describe "instance methods" do
    let(:pocao) { described_class.first }

    describe "#attributes" do
      it "exposes id, subtipo and pm_cost" do
        expect(pocao.id).to be_present
        expect(pocao.subtipo).to be_present
        expect(pocao.pm_cost).to be_an(Integer)
      end
    end
  end
end
