# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Distincao do
  describe "table" do
    it "uses the distincoes table" do
      expect(described_class.table_name).to eq("distincoes")
    end
  end

  describe "data integrity" do
    it "has distincoes loaded" do
      expect(described_class.count).to be_positive
    end

    it "each distincao has id, name, admissao, marca and nivel_minimo 5 (veterano)" do
      described_class.find_each do |d|
        expect(d.id).to be_present
        expect(d.name).to be_present
        expect(d.admissao).to be_present
        expect(d.marca_nome).to be_present
        expect(d.marca_descricao).to be_present
        expect(d.nivel_minimo).to eq(5)
      end
    end
  end

  describe "#poderes" do
    it "every distincao has at least one poder_distincao belonging to it" do
      described_class.find_each do |d|
        expect(d.poderes).not_to be_empty, "#{d.id}: has no poder_distincao powers"
        d.poderes.each do |poder|
          expect(poder.type).to eq("poder_distincao")
          expect(poder.distincao_id).to eq(d.id)
        end
      end
    end
  end

  it "finds a known distincao by id" do
    amazona = described_class.find("amazona")
    expect(amazona.name).to eq("Amazona")
    expect(amazona.nivel_minimo).to eq(5)
    expect(amazona.livro_id).to eq("herois_de_arton")
  end
end
