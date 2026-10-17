# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Magic esoteric implements (staffs, wands, holy symbols) used by spellcasters.
    #
    # @example
    #   EsotericoMagico.menores.all
    #   EsotericoMagico.find_by(id: "cajado_do_poder").effects
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier
    # @!attribute [rw] name
    #   @return [String] Item name
    # @!attribute [rw] categoria
    #   @return [String] Power tier: +"menor"+, +"medio"+, or +"maior"+
    # @!attribute [rw] preco
    #   @return [Integer, nil] Price in tibares
    # @!attribute [rw] roll_min
    #   @return [Integer, nil] Minimum roll on random loot table
    # @!attribute [rw] roll_max
    #   @return [Integer, nil] Maximum roll on random loot table
    # @!attribute [rw] description
    #   @return [String, nil] Item description
    class EsotericoMagico < Base
      self.table_name = "esotericos_magicos"

      # @!group Scopes
      # @!method menores
      #   @return [ActiveRecord::Relation] Minor-tier esoterics
      scope :menores, -> { where(categoria: "menor") }
      # @!method medios
      #   @return [ActiveRecord::Relation] Medium-tier esoterics
      scope :medios,  -> { where(categoria: "medio") }
      # @!method maiores
      #   @return [ActiveRecord::Relation] Major-tier esoterics
      scope :maiores, -> { where(categoria: "maior") }
      # @!endgroup

      def to_h
        {
          id: id, name: name, categoria: categoria, preco: preco,
          roll_min: roll_min, roll_max: roll_max,
          description: description, effects: effects
        }.compact
      end
    end
  end
end
