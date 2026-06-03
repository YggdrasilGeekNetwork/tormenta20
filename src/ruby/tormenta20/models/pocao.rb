# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Consumable magic items: potions, oils, and grenades.
    #
    # All three subtypes replicate spell effects at a fixed PM cost.
    #
    # @example
    #   Pocao.pocoes.menores.all
    #   Pocao.oleos.all
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier
    # @!attribute [rw] name
    #   @return [String] Item name
    # @!attribute [rw] subtipo
    #   @return [String] +"pocao"+, +"oleo"+, or +"granada"+
    # @!attribute [rw] spell_id
    #   @return [String] ID of the replicated spell
    # @!attribute [rw] pm_cost
    #   @return [Integer] PM cost of the replicated spell effect
    # @!attribute [rw] categoria
    #   @return [String] Power tier: +"menor"+, +"media"+, or +"maior"+
    # @!attribute [rw] preco
    #   @return [Integer, nil] Price in tibares
    # @!attribute [rw] roll_min
    #   @return [Integer, nil] Minimum roll on random loot table
    # @!attribute [rw] roll_max
    #   @return [Integer, nil] Maximum roll on random loot table
    # @!attribute [rw] aprimoramento
    #   @return [String, nil] Enhancement level identifier
    # @!attribute [rw] description
    #   @return [String, nil] Item description
    class Pocao < Base
      self.table_name = "pocoes"

      # @!group Scopes
      # @!method menores
      #   @return [ActiveRecord::Relation] Potions of minor power tier
      scope :menores,  -> { where(categoria: "menor") }
      # @!method medias
      #   @return [ActiveRecord::Relation] Potions of medium power tier
      scope :medias,   -> { where(categoria: "medio") }
      # @!method maiores
      #   @return [ActiveRecord::Relation] Potions of major power tier
      scope :maiores,  -> { where(categoria: "maior") }
      # @!method pocoes
      #   @return [ActiveRecord::Relation] Only potions (subtipo = "pocao")
      scope :pocoes,   -> { where(subtipo: "pocao") }
      # @!method oleos
      #   @return [ActiveRecord::Relation] Only oils (subtipo = "oleo")
      scope :oleos,    -> { where(subtipo: "oleo") }
      # @!method granadas
      #   @return [ActiveRecord::Relation] Only grenades (subtipo = "granada")
      scope :granadas, -> { where(subtipo: "granada") }
      # @!endgroup
    end
  end
end
