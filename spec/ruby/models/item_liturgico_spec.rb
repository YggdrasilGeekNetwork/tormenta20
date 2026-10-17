# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::ItemLiturgico do
  describe "table" do
    it "uses the itens_liturgicos table" do
      expect(described_class.table_name).to eq("itens_liturgicos")
    end
  end

  describe "data integrity" do
    it "has itens liturgicos loaded" do
      expect(described_class.count).to be_positive
    end

    it "each item has id, name and at least one deity" do
      described_class.find_each do |i|
        expect(i.id).to be_present
        expect(i.name).to be_present
        expect(i.deities).to be_an(Array)
        expect(i.deities).not_to be_empty
      end
    end

    it "each item has a non-empty effects array of typed objects" do
      described_class.find_each do |i|
        expect(i.effects).to be_an(Array)
        expect(i.effects).not_to be_empty
        i.effects.each { |effect| expect(effect["type"]).to be_a(String) }
      end
    end
  end

  describe ".by_deity" do
    it "returns only items associated with the given deity" do
      item = described_class.first
      described_class.by_deity(item.deities.first).each { |i| expect(i.deities).to include(item.deities.first) }
    end
  end

  describe ".by_subtipo" do
    it "returns only items of the given subtipo" do
      item = described_class.where.not(subtipo: nil).first
      described_class.by_subtipo(item.subtipo).each { |i| expect(i.subtipo).to eq(item.subtipo) }
    end
  end

  describe "instance methods" do
    let(:item) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = item.to_h
        expect(hash[:id]).to eq(item.id)
        expect(hash[:deities]).to be_an(Array)
        expect(hash[:effects]).to be_an(Array)
      end
    end
  end
end
