# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a MaterialEspecial (Special Material) in Tormenta20.
    #
    # Special materials can be used to craft weapons and armor,
    # providing additional effects and modifying the item's price.
    #
    # @example Find all special materials
    #   Tormenta20.materiais_especiais.all
    #
    # @example Find a specific material
    #   Tormenta20.materiais_especiais.find("adamante")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "adamante")
    # @!attribute [rw] name
    #   @return [String] Material name in Portuguese
    # @!attribute [rw] description
    #   @return [String, nil] Material description
    # @!attribute [rw] applicable_to
    #   @return [Array<String>, nil] Item types this material can be applied to
    # @!attribute [rw] price_modifier
    #   @return [String, nil] Price modifier when using this material
    # @!attribute [rw] effects
    #   @return [Array<String>, nil] Effects provided by this material
    class MaterialEspecial < Base
      self.table_name = "materiais_especiais"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      # Convert the special material to a hash representation.
      #
      # @return [Hash] Hash with all material attributes (nil values excluded)
      def to_h
        {
          id: id,
          name: name,
          description: description,
          applicable_to: applicable_to,
          price_modifier: price_modifier,
          effects: effects
        }.compact
      end
    end
  end
end
