# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Raca do
  describe "table" do
    it "uses the racas table" do
      expect(described_class.table_name).to eq("racas")
    end
  end

  describe "data integrity" do
    it "has racas loaded from JSON" do
      expect(described_class.count).to be > 0
    end

    it "each raca has movement > 0" do
      described_class.find_each do |r|
        expect(r.movement).to be > 0
      end
    end
  end

  describe "instance methods" do
    let(:humano) { described_class.find_by(id: "humano") }

    describe "#attribute_bonus_for" do
      it "returns 0 when there is no bonus" do
        expect(humano.attribute_bonus_for("forca")).to eq(0)
      end
    end

    describe "#visao_no_escuro?" do
      it "returns false for humano" do
        expect(humano.visao_no_escuro?).to be false
      end
    end

    describe "#to_h" do
      it "returns a hash with size and movement" do
        hash = humano.to_h
        expect(hash[:size]).to eq("médio")
        expect(hash[:movement]).to be > 0
      end
    end
  end
end
