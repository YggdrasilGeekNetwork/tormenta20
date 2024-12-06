# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Regra (Rule) in Tormenta20.
    #
    # Rules contain structured data about game mechanics such as
    # skills, conditions, combat rules, and other game systems.
    #
    # @example Find all rules
    #   Tormenta20.regras.all
    #
    # @example Find a specific rule
    #   Tormenta20.regras.find("pericias")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "pericias")
    # @!attribute [rw] name
    #   @return [String] Rule name in Portuguese
    # @!attribute [rw] description
    #   @return [String, nil] Rule description
    # @!attribute [rw] data
    #   @return [Hash, Array] Structured rule data (JSON)
    class Regra < Base
      self.table_name = "regras"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :data, presence: true

      # Convert the rule to a hash representation.
      #
      # @return [Hash] Hash with all rule attributes (nil values excluded)
      def to_h
        {
          id: id,
          name: name,
          description: description,
          data: data
        }.compact
      end
    end
  end
end
