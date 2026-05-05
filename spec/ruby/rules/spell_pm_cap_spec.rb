# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Rules::PmCap do
  describe ".for_ability" do
    it "returns class_level when a source class is provided" do
      expect(described_class.for_ability(source_class: "arcanista", class_level: 7, character_level: 10)).to eq(7)
    end

    it "returns character_level when source_class is nil (race/origin power)" do
      expect(described_class.for_ability(source_class: nil, class_level: nil, character_level: 10)).to eq(10)
    end

    it "returns character_level when class_level is nil" do
      expect(described_class.for_ability(source_class: "guerreiro", class_level: nil, character_level: 8)).to eq(8)
    end
  end
end
