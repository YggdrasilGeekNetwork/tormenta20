# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing an Escudo (Shield) in Tormenta20.
    #
    # Shields provide additional defense bonuses but may impose
    # armor penalties on certain skill checks.
    #
    # @example Find all shields
    #   Tormenta20.escudos.all
    #
    # @example Find shield with highest defense
    #   Tormenta20.escudos.order(defense_bonus: :desc).first
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "escudo_leve")
    # @!attribute [rw] name
    #   @return [String] Shield name in Portuguese
    # @!attribute [rw] price
    #   @return [String] Price in Tormenta currency
    # @!attribute [rw] defense_bonus
    #   @return [Integer] Defense bonus provided by the shield
    # @!attribute [rw] armor_penalty
    #   @return [Integer] Armor penalty for skill checks
    # @!attribute [rw] weight
    #   @return [String] Weight in slots/spaces
    # @!attribute [rw] properties
    #   @return [Array<String>] Special shield properties
    # @!attribute [rw] description
    #   @return [String, nil] Optional description
    class Escudo < Base
      self.table_name = "escudos"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :defense_bonus, presence: true

      # Convert the shield to a hash representation.
      #
      # @return [Hash] Hash with all shield attributes (nil values excluded)
      def to_h
        {
          id: id,
          name: name,
          price: price,
          defense_bonus: defense_bonus,
          armor_penalty: armor_penalty,
          weight: weight,
          properties: properties,
          description: description
        }.compact
      end
    end
  end
end
