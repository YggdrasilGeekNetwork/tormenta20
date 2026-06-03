# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Item do
  describe "table" do
    it "uses the itens table" do
      expect(described_class.table_name).to eq("itens")
    end
  end

  describe "data integrity" do
    it "has itens loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each item has id and name" do
      described_class.find_each do |i|
        expect(i.id).to be_present
        expect(i.name).to be_present
      end
    end
  end

  describe "scopes" do
    describe ".by_category" do
      it "filters by category" do
        cats = described_class.select(:category).distinct.pluck(:category).compact
        cats.each do |cat|
          described_class.by_category(cat).each { |i| expect(i.category).to eq(cat) }
        end
      end
    end
  end

  describe "instance methods" do
    let(:item) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = item.to_h
        expect(hash[:id]).to eq(item.id)
        expect(hash[:name]).to eq(item.name)
      end
    end
  end
end
