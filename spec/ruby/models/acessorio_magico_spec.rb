# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::AcessorioMagico do
  describe "table" do
    it "uses the acessorios_magicos table" do
      expect(described_class.table_name).to eq("acessorios_magicos")
    end
  end

  describe "data integrity" do
    it "has acessorios loaded" do
      expect(described_class.count).to be_positive
    end

    it "each acessorio has id, name, and categoria" do
      described_class.find_each do |a|
        expect(a.id).to be_present
        expect(a.name).to be_present
        expect(a.categoria).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".menores" do
      it "returns only menor category" do
        described_class.menores.each { |a| expect(a.categoria).to eq("menor") }
      end
    end

    describe ".maiores" do
      it "returns only maior category" do
        described_class.maiores.each { |a| expect(a.categoria).to eq("maior") }
      end
    end
  end

  describe "instance methods" do
    let(:acessorio) { described_class.first }

    describe "#efeito" do
      it "returns a hash" do
        expect(acessorio.efeito).to be_a(Hash)
      end
    end

    describe "#attributes" do
      it "exposes id and categoria" do
        expect(acessorio.id).to be_present
        expect(acessorio.categoria).to be_present
      end
    end
  end
end
