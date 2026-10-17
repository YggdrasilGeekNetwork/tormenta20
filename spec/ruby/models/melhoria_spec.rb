# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Melhoria do
  describe "table" do
    it "uses the melhorias table" do
      expect(described_class.table_name).to eq("melhorias")
    end
  end

  describe "data integrity" do
    it "has melhorias loaded from JSON" do
      expect(described_class.count).to be_positive
    end

    it "each melhoria has id and name" do
      described_class.find_each do |m|
        expect(m.id).to be_present
        expect(m.name).to be_present
      end
    end
  end

  describe "data integrity" do
    it "each melhoria has a non-empty effects array of typed objects" do
      described_class.find_each do |m|
        expect(m.effects).to be_an(Array)
        expect(m.effects).not_to be_empty
        m.effects.each { |effect| expect(effect["type"]).to be_a(String) }
      end
    end
  end

  describe "instance methods" do
    let(:melhoria) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = melhoria.to_h
        expect(hash[:id]).to eq(melhoria.id)
        expect(hash[:name]).to eq(melhoria.name)
        expect(hash[:effects]).to be_an(Array)
      end
    end
  end
end
