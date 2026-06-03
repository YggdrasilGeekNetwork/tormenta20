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

  describe "instance methods" do
    let(:melhoria) { described_class.first }

    describe "#to_h" do
      it "returns a hash representation" do
        hash = melhoria.to_h
        expect(hash[:id]).to eq(melhoria.id)
        expect(hash[:name]).to eq(melhoria.name)
        expect(hash[:effects]).to be_a(Hash)
      end
    end
  end
end
