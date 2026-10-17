# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Rules::DamageStep do
  describe ".adjust" do
    it "steps up by 1" do
      expect(described_class.adjust("1d8", 1)).to eq("1d10")
    end

    it "steps up by 2" do
      expect(described_class.adjust("1d8", 2)).to eq("1d12")
    end

    it "steps up by the maximum, 3" do
      expect(described_class.adjust("1d8", 3)).to eq("3d6")
    end

    it "steps down by 1" do
      expect(described_class.adjust("1d8", -1)).to eq("1d6")
    end

    it "steps down by the minimum, -2" do
      expect(described_class.adjust("1d8", -2)).to eq("1d4")
    end

    it "returns the same die when steps is 0" do
      expect(described_class.adjust("1d10", 0)).to eq("1d10")
    end

    it "clamps steps beyond +3 to the top of the table" do
      expect(described_class.adjust("1d8", 10)).to eq(described_class.adjust("1d8", 3))
    end

    it "clamps steps below -2 to the bottom of the table" do
      expect(described_class.adjust("1d8", -10)).to eq(described_class.adjust("1d8", -2))
    end

    it "returns nil for a die that isn't a normal-column entry" do
      expect(described_class.adjust("1d20", 1)).to be_nil
    end

    it "works at the top row of the table" do
      expect(described_class.adjust("2d10", 1)).to eq("3d10")
    end

    it "works at the bottom row of the table" do
      expect(described_class.adjust("1d3", -1)).to eq("1d2")
    end
  end
end
