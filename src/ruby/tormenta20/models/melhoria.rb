# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Melhoria (Enhancement/Upgrade) in Tormenta20.
    #
    # Enhancements can be applied to weapons, armor, and other items
    # to provide magical bonuses and special effects.
    #
    # @example Find all enhancements
    #   Tormenta20.melhorias.all
    #
    # @example Find a specific enhancement
    #   Tormenta20.melhorias.find("flamejante")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "flamejante")
    # @!attribute [rw] name
    #   @return [String] Enhancement name in Portuguese
    # @!attribute [rw] description
    #   @return [String, nil] Enhancement description
    # @!attribute [rw] applicable_to
    #   @return [Array<String>, nil] Item types this enhancement can be applied to
    # @!attribute [rw] price
    #   @return [String, nil] Price or price modifier for this enhancement
    # @!attribute [rw] effects
    #   @return [Array<String>, nil] Effects provided by this enhancement
    class Melhoria < Base
      self.table_name = "melhorias"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      # Convert the enhancement to a hash representation.
      #
      # @return [Hash] Hash with all enhancement attributes (nil values excluded)
      def to_h
        {
          id: id,
          name: name,
          description: description,
          applicable_to: applicable_to,
          price: price,
          effects: effects
        }.compact
      end
    end
  end
end
