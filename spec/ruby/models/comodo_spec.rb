# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Comodo do
  describe "table" do
    it "uses the comodos table" do
      expect(described_class.table_name).to eq("comodos")
    end
  end

  describe "data integrity" do
    it "has the 41 cômodos loaded" do
      expect(described_class.count).to eq(41)
    end

    it "each cômodo has id, name, description and non-empty effects" do
      described_class.find_each do |c|
        expect(c.id).to be_present
        expect(c.name).to be_present
        expect(c.description).to be_present
        expect(c.effects).to be_an(Array)
        expect(c.effects).not_to be_empty
      end
    end

    it "some cômodos have a prerequisito and most don't" do
      with_prereq = described_class.where.not(prerequisito: nil)
      expect(with_prereq.count).to be_positive
      expect(with_prereq.count).to be < described_class.count
    end
  end

  describe "instance methods" do
    let(:comodo) do
      described_class.new(
        id: "biblioteca", name: "Biblioteca",
        description: "Estantes recheadas de livros e pergaminhos. Os residentes recebem +1 em Conhecimento.",
        effects: [{ "type" => "bonus_pericia", "pericia" => "conhecimento", "value" => 1 }],
        prerequisito: nil
      )
    end

    describe "#to_h" do
      it "returns a hash representation" do
        hash = comodo.to_h
        expect(hash[:id]).to eq("biblioteca")
        expect(hash[:effects]).to be_an(Array)
      end
    end

    it "supports a prerequisito" do
      restrito = described_class.new(id: "sauna", name: "Sauna", prerequisito: "base formidável ou melhor")
      expect(restrito.prerequisito).to eq("base formidável ou melhor")
    end
  end
end
