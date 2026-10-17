# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Ameaca do
  describe "table" do
    it "uses the ameacas table" do
      expect(described_class.table_name).to eq("ameacas")
    end
  end

  describe "data integrity" do
    it "has ameacas loaded" do
      expect(described_class.count).to be_positive
    end

    it "every ameaca has required fields" do
      described_class.find_each do |a|
        expect(a.id).to be_present
        expect(a.name).to be_present
        expect(a.grupo).to be_present
        expect(a.nd).to be_a(Numeric)
        expect(a.tamanho).to be_present
      end
    end

    it "every ameaca has structured ataques" do
      described_class.find_each do |a|
        expect(a.ataques).to be_an(Array)
        a.ataques.each do |atk|
          expect(atk).to have_key("nome")
          expect(atk).to have_key("bonus")
          next if atk["dano"].nil?

          components = atk["dano"]
          expect(components).to be_an(Array)
          expect(components).not_to be_empty
          components.each { |comp| expect(comp["dados"]).to be_an(Array) }
        end
      end
    end

    it "salvaguardas have fort, ref and von" do
      described_class.find_each do |a|
        expect(a.salvaguardas).to have_key("fort")
        expect(a.salvaguardas).to have_key("ref")
        expect(a.salvaguardas).to have_key("von")
      end
    end
  end

  describe "find" do
    it "returns the correct ameaca by id" do
      basilisco = described_class.find_by(id: "basilisco")
      expect(basilisco.name).to eq("Basilisco")
      expect(basilisco.nd).to eq(4)
      expect(basilisco.grupo).to eq("ermos")
    end

    it "returns nil for unknown id" do
      expect(described_class.find_by(id: "nonexistent")).to be_nil
    end
  end

  describe "scopes" do
    it "by_grupo returns only ameacas of that group" do
      dragoes = described_class.dragoes
      expect(dragoes).not_to be_empty
      dragoes.each { |a| expect(a.grupo).to eq("dragoes") }
    end

    it "by_nd returns only ameacas with exact nd" do
      result = described_class.by_nd(1)
      expect(result).not_to be_empty
      result.each { |a| expect(a.nd).to eq(1) }
    end

    it "avatares returns only ameacas in the avatares group" do
      avatares = described_class.avatares
      expect(avatares.count).to eq(20)
      avatares.each { |a| expect(a.grupo).to eq("avatares") }
    end
  end

  describe "instance methods" do
    it "atributos returns all six attribute modifiers" do
      a = described_class.find_by(id: "basilisco")
      attrs = a.atributos
      expect(attrs).to have_key(:for)
      expect(attrs).to have_key(:des)
      expect(attrs).to have_key(:con)
      expect(attrs).to have_key(:int)
      expect(attrs).to have_key(:sab)
      expect(attrs).to have_key(:car)
    end

    describe "#to_h" do
      it "returns a hash representation with all expected keys" do
        a = described_class.first
        hash = a.to_h
        expect(hash[:id]).to eq(a.id)
        expect(hash[:name]).to eq(a.name)
        expect(hash[:nd]).to eq(a.nd)
        expect(hash[:grupo]).to eq(a.grupo)
        expect(hash[:tamanho]).to eq(a.tamanho)
      end
    end

    it "poderes_especiais is an array" do
      a = described_class.find_by(id: "basilisco")
      expect(a.poderes_especiais).to be_an(Array)
      expect(a.poderes_especiais).not_to be_empty
    end
  end

  describe "novos campos (imunidades, resistencias, reducao de dano, etc.)" do
    it "imunidades, vulnerabilidades and equipamento are arrays" do
      described_class.find_each do |a|
        expect(a.imunidades).to be_an(Array)
        expect(a.vulnerabilidades).to be_an(Array)
        expect(a.equipamento).to be_an(Array)
      end
    end

    it "resistencias and pericias are hashes" do
      described_class.find_each do |a|
        expect(a.resistencias).to be_a(Hash)
        expect(a.pericias).to be_a(Hash)
      end
    end

    it "dragao_adulto has a numeric reducao_de_dano" do
      dragao = described_class.find_by(id: "dragao_adulto")
      expect(dragao.reducao_de_dano).to eq(10)
    end

    it "vampiro has a string reducao_de_dano with an exception" do
      vampiro = described_class.find_by(id: "vampiro")
      expect(vampiro.reducao_de_dano).to eq("10/luz")
    end

    it "cultista_de_sszzaas has pm and non-empty pericias" do
      cultista = described_class.find_by(id: "cultista_de_sszzaas")
      expect(cultista.pm).to eq(40)
      expect(cultista.pericias).not_to be_empty
    end

    it "tesouro is present for every ameaca" do
      described_class.find_each do |a|
        expect(a.tesouro).to be_present
      end
    end

    it "vampiro has cura_acelerada and dragao_adulto has resistencia_a_magia (previously dropped by the seeder)" do
      vampiro = described_class.find_by(id: "vampiro")
      expect(vampiro.cura_acelerada).to eq(10)
      dragao = described_class.find_by(id: "dragao_adulto")
      expect(dragao.resistencia_a_magia).to eq(3)
    end

    it "avatar_de_megalokk has a string cura_acelerada with an exception" do
      megalokk = described_class.find_by(id: "avatar_de_megalokk")
      expect(megalokk.cura_acelerada).to eq("100/kaiju")
    end

    it "bogum has a tiered parceiro and no familiar" do
      bogum = described_class.find_by(id: "bogum")
      expect(bogum.parceiro).to include("iniciante", "veterano", "mestre")
      expect(bogum.familiar).to be_nil
    end

    it "homunculo has both familiar and parceiro" do
      homunculo = described_class.find_by(id: "homunculo")
      expect(homunculo.familiar).to be_present
      expect(homunculo.parceiro).to include("iniciante", "veterano", "mestre")
    end
  end

  describe "nd values" do
    it "fractional nd creatures exist (ND 1/4 = 0.25, ND 1/2 = 0.5)" do
      expect(described_class.by_nd(0.25).count).to be_positive
      expect(described_class.by_nd(0.5).count).to be_positive
    end

    it "dragao_rei has nd 20" do
      expect(described_class.find_by(id: "dragao_rei").nd).to eq(20)
    end

    it "dragao_filhote has nd 3 with correct stats" do
      filhote = described_class.find_by(id: "dragao_filhote")
      expect(filhote.nd).to eq(3)
      expect(filhote.pv).to eq(140)
      expect(filhote.defesa).to eq(22)
    end
  end
end
