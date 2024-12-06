# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Tormenta20::Database do
  describe "connection" do
    it "can execute queries" do
      result = ActiveRecord::Base.connection.execute("SELECT 1")
      expect(result).not_to be_nil
    end
  end

  describe ".db_path" do
    it "returns the database path" do
      expect(described_class.db_path).to be_a(String)
      expect(described_class.db_path).to end_with("tormenta20.sqlite3")
    end
  end

  describe ".default_db_path" do
    it "returns the default database path" do
      expect(described_class.default_db_path).to be_a(String)
      expect(described_class.default_db_path).to end_with("db/tormenta20.sqlite3")
    end
  end

  describe ".schema_path" do
    it "returns the schema file path" do
      expect(described_class.schema_path).to be_a(String)
      expect(described_class.schema_path).to end_with("db/schema.sql")
    end
  end

  describe "database content" do
    it "has all required tables" do
      tables = ActiveRecord::Base.connection.tables
      expected_tables = %w[origens poderes divindades classes magias escudos materiais_especiais regras]
      expected_tables.each do |table|
        expect(tables).to include(table), "Expected table '#{table}' to exist"
      end
    end
  end

  describe "data counts" do
    it "has origens loaded" do
      expect(Tormenta20::Models::Origem.count).to be > 0
    end

    it "has poderes loaded" do
      expect(Tormenta20::Models::Poder.count).to be > 0
    end

    it "has divindades loaded" do
      expect(Tormenta20::Models::Divindade.count).to be > 0
    end

    it "has classes loaded" do
      expect(Tormenta20::Models::Classe.count).to be > 0
    end

    it "has magias loaded" do
      expect(Tormenta20::Models::Magia.count).to be > 0
    end

    it "has escudos loaded" do
      expect(Tormenta20::Models::Escudo.count).to be > 0
    end

    it "has materiais_especiais loaded" do
      expect(Tormenta20::Models::MaterialEspecial.count).to be > 0
    end

    it "has regras loaded" do
      expect(Tormenta20::Models::Regra.count).to be > 0
    end
  end
end
