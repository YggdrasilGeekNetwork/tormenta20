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
      expect(described_class.count).to be_positive
    end

    it "each raca has movement > 0" do
      described_class.find_each do |r|
        expect(r.movement).to be_positive
      end
    end
  end

  describe "Heróis de Arton fields" do
    it "galokk and meio_elfo use chosen_attribute_bonus instead of a fixed value for their extra bonus" do
      galokk = described_class.find("galokk")
      expect(galokk.chosen_attribute_bonus).to eq({ "count" => 1, "value" => 1, "exclude" => [] })

      meio_elfo = described_class.find("meio_elfo")
      expect(meio_elfo.chosen_attribute_bonus).to eq({ "count" => 2, "value" => 1, "exclude" => ["constituicao"] })
    end

    it "humano (EJA) has no chosen_attribute_bonus, longevidade or devocao" do
      humano = described_class.find("humano")
      expect(humano.chosen_attribute_bonus).to be_nil
      expect(humano.longevidade).to be_nil
      expect(humano.devocao).to be_nil
    end

    it "eiradaan has longevidade and devocao populated" do
      eiradaan = described_class.find("eiradaan")
      expect(eiradaan.longevidade).to eq("x5")
      expect(eiradaan.devocao).to eq(%w[allihanna lena thyatis wynna])
    end

    it "every racial_abilities and available_chosen_abilities id resolves to a real habilidade_de_raca poder" do
      described_class.find_each do |raca|
        (raca.racial_abilities + raca.available_chosen_abilities).each do |ability_id|
          poder = Tormenta20::Models::Poder.find_by(id: ability_id)
          expect(poder).not_to be_nil, "#{raca.id}: racial ability #{ability_id} not found in poderes"
          expect(poder.type).to eq("habilidade_de_raca")
        end
      end
    end

    it "duende uses chosen_abilities_amount for its 3 presentes, chosen from 12 options" do
      duende = described_class.find("duende")
      expect(duende.chosen_abilities_amount).to eq(3)
      expect(duende.available_chosen_abilities.size).to eq(12)
    end
  end

  describe "Deuses de Arton fields" do
    it "aggelus and sulfure share the same 22-option ability_swap pool, replacing their own fixed ability" do
      aggelus = described_class.find("aggelus")
      expect(aggelus.ability_swap["replaces"]).to eq("luz_sagrada")
      expect(aggelus.ability_swap["options"].size).to eq(22)

      sulfure = described_class.find("sulfure")
      expect(sulfure.ability_swap["replaces"]).to eq("sombras_profanas")
      expect(sulfure.ability_swap["options"]).to eq(aggelus.ability_swap["options"])
    end

    it "every ability_swap option resolves to a real habilidade_de_raca poder from Deuses de Arton" do
      described_class.find_each do |raca|
        next unless raca.ability_swap

        raca.ability_swap["options"].each do |ability_id|
          poder = Tormenta20::Models::Poder.find_by(id: ability_id)
          expect(poder).not_to be_nil, "#{raca.id}: ability_swap option #{ability_id} not found in poderes"
          expect(poder.type).to eq("habilidade_de_raca")
        end
      end
    end

    it "races without variants have no ability_swap" do
      expect(described_class.find("humano").ability_swap).to be_nil
    end
  end

  describe "Ameaças de Arton races (Brutos & Indomáveis)" do
    it "loads meio_orc, orc, tabrachi, trog_anao and ogro with chosen_attribute_bonus or devocao as appropriate" do
      meio_orc = described_class.find("meio_orc")
      expect(meio_orc.chosen_attribute_bonus).to eq({ "count" => 1, "value" => 1, "exclude" => ["carisma"] })

      orc = described_class.find("orc")
      expect(orc.devocao).to contain_exactly("allihanna", "arsenal", "megalokk", "nimb", "tenebra")

      trog_anao = described_class.find("trog_anao")
      expect(trog_anao.racial_abilities).to include("quase_anao")
      expect(trog_anao.attribute_bonus_for("destreza")).to eq(-1)

      ogro = described_class.find("ogro")
      expect(ogro.size).to eq("grande")
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
        expect(hash[:movement]).to be_positive
      end
    end
  end
end
