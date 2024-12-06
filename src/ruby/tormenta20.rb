# frozen_string_literal: true

require "json"
require "active_record"
require "sqlite3"

require_relative "tormenta20/database"

# Load base model first, then other models
require_relative "tormenta20/models/base"
Dir["#{__dir__}/tormenta20/models/*.rb"].each { |file| require file unless file.include?("base") }

# Load other modules
Dir["#{__dir__}/tormenta20/*.rb"].each { |file| require file unless file.include?("database") }

# Tormenta20 is a Ruby library providing data about the Brazilian TTRPG Tormenta20.
#
# It includes a pre-built SQLite database with information about spells, classes,
# origins, deities, powers, and equipment from the Tormenta20 system.
#
# @example Basic usage
#   require 'tormenta20'
#
#   # Query spells
#   Tormenta20.magias.arcanas.by_circle("3")
#
#   # Find a specific class
#   Tormenta20.classes.find("guerreiro")
#
# @author LuanGB
# @see https://github.com/LuanGB/tormenta20
module Tormenta20
  class << self
    # Configure and setup the database connection.
    #
    # @param mode [Symbol] Database mode:
    #   - `:builtin` - Use pre-built database (default)
    #   - `:build` - Build database on load
    #   - `:lazy` - Build database on first use
    # @param db_path [String, nil] Custom path to SQLite database file
    # @return [void]
    #
    # @example Use default builtin database
    #   Tormenta20.setup
    #
    # @example Use custom database path
    #   Tormenta20.setup(db_path: "/path/to/custom.sqlite3")
    def setup(mode: :builtin, db_path: nil)
      Database.setup(mode: mode, db_path: db_path)
    end

    # @!group Query Interface

    # Access the Origem (Origin) model for querying character origins.
    #
    # @return [Class<Models::Origem>] The Origem model class
    # @example
    #   Tormenta20.origens.all
    #   Tormenta20.origens.with_unique_power
    def origens
      Models::Origem
    end

    # Access the Poder (Power) model for querying powers and abilities.
    #
    # @return [Class<Models::Poder>] The Poder model class
    # @example
    #   Tormenta20.poderes.poderes_concedidos
    #   Tormenta20.poderes.by_type("poder_tormenta")
    def poderes
      Models::Poder
    end

    # Access the Divindade (Deity) model for querying deities.
    #
    # @return [Class<Models::Divindade>] The Divindade model class
    # @example
    #   Tormenta20.divindades.energia_positiva
    #   Tormenta20.divindades.find("khalmyr")
    def divindades
      Models::Divindade
    end

    # Access the Classe (Character Class) model for querying classes.
    #
    # @return [Class<Models::Classe>] The Classe model class
    # @example
    #   Tormenta20.classes.conjuradores
    #   Tormenta20.classes.find("arcanista")
    def classes
      Models::Classe
    end

    # Access the Magia (Spell) model for querying spells.
    #
    # @return [Class<Models::Magia>] The Magia model class
    # @example
    #   Tormenta20.magias.arcanas
    #   Tormenta20.magias.by_circle("3").by_school("evoc")
    def magias
      Models::Magia
    end

    # Access the Arma (Weapon) model for querying weapons.
    #
    # @return [Class<Models::Arma>] The Arma model class
    # @example
    #   Tormenta20.armas.simples
    #   Tormenta20.armas.ranged
    def armas
      Models::Arma
    end

    # Access the Armadura (Armor) model for querying armors.
    #
    # @return [Class<Models::Armadura>] The Armadura model class
    # @example
    #   Tormenta20.armaduras.leves
    #   Tormenta20.armaduras.pesadas
    def armaduras
      Models::Armadura
    end

    # Access the Escudo (Shield) model for querying shields.
    #
    # @return [Class<Models::Escudo>] The Escudo model class
    # @example
    #   Tormenta20.escudos.all
    def escudos
      Models::Escudo
    end

    # Access the Item model for querying general items.
    #
    # @return [Class<Models::Item>] The Item model class
    # @example
    #   Tormenta20.itens.by_category("alquimico")
    def itens
      Models::Item
    end

    # Access the MaterialEspecial (Special Material) model.
    #
    # @return [Class<Models::MaterialEspecial>] The MaterialEspecial model class
    # @example
    #   Tormenta20.materiais_especiais.all
    def materiais_especiais
      Models::MaterialEspecial
    end

    # Access the Melhoria (Enhancement) model for querying magic enhancements.
    #
    # @return [Class<Models::Melhoria>] The Melhoria model class
    # @example
    #   Tormenta20.melhorias.all
    def melhorias
      Models::Melhoria
    end

    # Access the Regra (Rule) model for querying rules and reference data.
    #
    # @return [Class<Models::Regra>] The Regra model class
    # @example
    #   Tormenta20.regras.find("pericias")
    def regras
      Models::Regra
    end

    # @!endgroup
  end

  # Auto-setup database when gem is loaded
  setup
end
