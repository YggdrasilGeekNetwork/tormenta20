# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Divindade (Deity) in Tormenta20.
    #
    # Deities grant powers to their followers and have specific energy types.
    #
    # @example Find deities with positive energy
    #   Divindade.energia_positiva
    #
    # @example Get deity's granted powers
    #   khalmyr = Divindade.find("khalmyr")
    #   khalmyr.granted_powers  # => ["coragem_total", "espada_justiceira", ...]
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "khalmyr")
    # @!attribute [rw] name
    #   @return [String] Deity name (e.g., "Khalmyr")
    # @!attribute [rw] title
    #   @return [String] Deity title (e.g., "O Deus da Justiça")
    # @!attribute [rw] energy
    #   @return [String] Energy type: "positiva", "negativa", or "qualquer"
    # @!attribute [rw] granted_powers
    #   @return [Array<String>] List of power IDs granted to followers
    class Divindade < Base
      self.table_name = "divindades"

      # Valid energy types for deities.
      ENERGIES = %w[positiva negativa qualquer].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :energy, presence: true, inclusion: { in: ENERGIES }

      # @!group Scopes

      # @!method energia_positiva
      #   Filter deities with positive energy.
      #   @return [ActiveRecord::Relation<Divindade>]
      scope :energia_positiva, -> { where(energy: "positiva") }

      # @!method energia_negativa
      #   Filter deities with negative energy.
      #   @return [ActiveRecord::Relation<Divindade>]
      scope :energia_negativa, -> { where(energy: "negativa") }

      # @!method energia_qualquer
      #   Filter deities with neutral/any energy.
      #   @return [ActiveRecord::Relation<Divindade>]
      scope :energia_qualquer, -> { where(energy: "qualquer") }

      # @!method by_energy(energy)
      #   Filter deities by energy type.
      #   @param energy [String] Energy type (positiva, negativa, qualquer)
      #   @return [ActiveRecord::Relation<Divindade>]
      scope :by_energy, ->(e) { where(energy: e) }

      # @!endgroup

      # Get races that typically worship this deity.
      #
      # @return [Array<String>] List of race names
      def races
        devotees&.dig("races") || []
      end

      # Get classes that typically worship this deity.
      #
      # @return [Array<String>] List of class names
      def classes
        devotees&.dig("classes") || []
      end

      # Convert deity to a hash representation.
      #
      # @return [Hash] Hash with all deity attributes
      def to_h
        {
          id: id,
          name: name,
          title: title,
          description: description,
          beliefs_objectives: beliefs_objectives,
          holy_symbol: holy_symbol,
          energy: energy,
          preferred_weapon: preferred_weapon,
          devotees: devotees,
          granted_powers: granted_powers,
          obligations_restrictions: obligations_restrictions
        }.compact
      end
    end
  end
end
