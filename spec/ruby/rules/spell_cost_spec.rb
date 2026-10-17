# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Rules::SpellCost do
  describe ".for_circle" do
    it "returns 1 PM for circle 1" do
      expect(described_class.for_circle(1)).to eq(1)
    end

    it "returns 3 PM for circle 2" do
      expect(described_class.for_circle(2)).to eq(3)
    end

    it "returns 6 PM for circle 3" do
      expect(described_class.for_circle(3)).to eq(6)
    end

    it "returns 10 PM for circle 4" do
      expect(described_class.for_circle(4)).to eq(10)
    end

    it "returns 15 PM for circle 5" do
      expect(described_class.for_circle(5)).to eq(15)
    end

    it "accepts a string circle, matching how Magia#circle is stored" do
      expect(described_class.for_circle("3")).to eq(6)
    end

    it "returns nil for an unknown circle" do
      expect(described_class.for_circle(6)).to be_nil
    end
  end
end
