# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing an Origem (Character Origin) in Tormenta20.
    #
    # Origins provide starting skills, items, and sometimes unique powers.
    #
    # @example Find origins with unique powers
    #   Origem.with_unique_power
    #
    # @example Get origin skills
    #   soldado = Origem.find("soldado")
    #   soldado.skills  # => ["Fortitude", "Luta"]
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "soldado")
    # @!attribute [rw] name
    #   @return [String] Origin name (e.g., "Soldado")
    # @!attribute [rw] description
    #   @return [String] Origin description
    # @!attribute [rw] items
    #   @return [Array] Starting items
    # @!attribute [rw] benefits
    #   @return [Hash] Benefits with "skills" and "powers" keys
    # @!attribute [rw] unique_power
    #   @return [Hash, nil] Unique power data or nil
    class Origem < Base
      self.table_name = "origens"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      # @!method with_unique_power
      #   Filter origins that have a unique power.
      #   @return [ActiveRecord::Relation<Origem>]
      scope :with_unique_power, -> { where.not(unique_power: nil) }

      # Get trained skills from this origin.
      #
      # @return [Array<String>] List of skill names
      def skills
        benefits&.dig("skills") || []
      end

      # Get powers granted by this origin.
      #
      # @return [Array<String>] List of power names
      def powers
        benefits&.dig("powers") || []
      end

      # Convert origin to a hash representation.
      #
      # @return [Hash] Hash with all origin attributes
      def to_h
        {
          id: id,
          name: name,
          description: description,
          items: items,
          benefits: benefits,
          unique_power: unique_power
        }.compact
      end
    end
  end
end
