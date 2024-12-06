# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe "Tormenta20 Query Interface" do
  describe ".origens" do
    it "returns the Origem model" do
      expect(Tormenta20.origens).to eq(Tormenta20::Models::Origem)
    end

    it "allows querying" do
      expect(Tormenta20.origens.count).to be > 0
    end

    it "allows chaining scopes" do
      expect(Tormenta20.origens.with_unique_power).to be_an(ActiveRecord::Relation)
    end
  end

  describe ".poderes" do
    it "returns the Poder model" do
      expect(Tormenta20.poderes).to eq(Tormenta20::Models::Poder)
    end

    it "allows querying" do
      expect(Tormenta20.poderes.count).to be > 0
    end

    it "allows chaining scopes" do
      expect(Tormenta20.poderes.habilidades_unicas).to be_an(ActiveRecord::Relation)
      expect(Tormenta20.poderes.poderes_concedidos).to be_an(ActiveRecord::Relation)
    end
  end

  describe ".divindades" do
    it "returns the Divindade model" do
      expect(Tormenta20.divindades).to eq(Tormenta20::Models::Divindade)
    end

    it "allows querying" do
      expect(Tormenta20.divindades.count).to be > 0
    end

    it "allows chaining scopes" do
      expect(Tormenta20.divindades.energia_positiva).to be_an(ActiveRecord::Relation)
    end
  end

  describe ".classes" do
    it "returns the Classe model" do
      expect(Tormenta20.classes).to eq(Tormenta20::Models::Classe)
    end

    it "allows querying" do
      expect(Tormenta20.classes.count).to be > 0
    end

    it "allows chaining scopes" do
      expect(Tormenta20.classes.conjuradores).to be_an(ActiveRecord::Relation)
    end
  end

  describe ".magias" do
    it "returns the Magia model" do
      expect(Tormenta20.magias).to eq(Tormenta20::Models::Magia)
    end

    it "allows querying" do
      expect(Tormenta20.magias.count).to be > 0
    end

    it "allows chaining scopes" do
      expect(Tormenta20.magias.arcanas).to be_an(ActiveRecord::Relation)
      expect(Tormenta20.magias.divinas).to be_an(ActiveRecord::Relation)
      expect(Tormenta20.magias.by_circle("1")).to be_an(ActiveRecord::Relation)
    end

    it "allows combining scopes" do
      result = Tormenta20.magias.arcanas.by_circle("1")
      expect(result).to be_an(ActiveRecord::Relation)
      result.each do |magia|
        expect(magia.type).to eq("arcana")
        expect(magia.circle).to eq("1")
      end
    end
  end

  describe ".armas" do
    it "returns the Arma model" do
      expect(Tormenta20.armas).to eq(Tormenta20::Models::Arma)
    end
  end

  describe ".armaduras" do
    it "returns the Armadura model" do
      expect(Tormenta20.armaduras).to eq(Tormenta20::Models::Armadura)
    end
  end

  describe ".escudos" do
    it "returns the Escudo model" do
      expect(Tormenta20.escudos).to eq(Tormenta20::Models::Escudo)
    end

    it "allows querying" do
      expect(Tormenta20.escudos.count).to be > 0
    end
  end

  describe ".itens" do
    it "returns the Item model" do
      expect(Tormenta20.itens).to eq(Tormenta20::Models::Item)
    end
  end

  describe ".materiais_especiais" do
    it "returns the MaterialEspecial model" do
      expect(Tormenta20.materiais_especiais).to eq(Tormenta20::Models::MaterialEspecial)
    end

    it "allows querying" do
      expect(Tormenta20.materiais_especiais.count).to be > 0
    end
  end

  describe ".melhorias" do
    it "returns the Melhoria model" do
      expect(Tormenta20.melhorias).to eq(Tormenta20::Models::Melhoria)
    end
  end

  describe ".regras" do
    it "returns the Regra model" do
      expect(Tormenta20.regras).to eq(Tormenta20::Models::Regra)
    end

    it "allows querying" do
      expect(Tormenta20.regras.count).to be > 0
    end
  end

  describe "find operations" do
    it "allows finding records by id" do
      origem = Tormenta20.origens.first
      found = Tormenta20.origens.find(origem.id)
      expect(found).to eq(origem)
    end

    it "allows where queries" do
      results = Tormenta20.magias.where(type: "arcana")
      expect(results).to be_an(ActiveRecord::Relation)
      results.each do |magia|
        expect(magia.type).to eq("arcana")
      end
    end
  end
end
