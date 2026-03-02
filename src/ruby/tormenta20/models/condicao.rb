# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Condição (Status Condition) in Tormenta20.
    #
    # Conditions represent temporary states that affect a character's
    # capabilities during play (e.g., Abalado, Cego, Paralisado).
    #
    # @example Find all conditions
    #   Tormenta20.condicoes.all
    #
    # @example Find conditions of a specific type
    #   Tormenta20.condicoes.by_type("medo")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "abalado")
    # @!attribute [rw] name
    #   @return [String] Condition name in Portuguese (e.g., "Abalado")
    # @!attribute [rw] description
    #   @return [String, nil] Full description of the condition
    # @!attribute [rw] effects
    #   @return [Array<String>] List of mechanical effects
    # @!attribute [rw] condition_type
    #   @return [String, nil] Category (medo, mental, metabolismo, movimento, veneno, sentidos, cansaco, metamorfose)
    # @!attribute [rw] escalates_to
    #   @return [String, nil] ID of the condition this escalates into when reapplied
    class Condicao < Base
      self.table_name = "condicoes"

      TYPES = %w[
        medo
        mental
        metabolismo
        movimento
        veneno
        sentidos
        cansaco
        metamorfose
      ].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      scope :by_type, ->(t) { where(condition_type: t) }
      scope :medo, -> { where(condition_type: "medo") }
      scope :mental, -> { where(condition_type: "mental") }
      scope :metabolismo, -> { where(condition_type: "metabolismo") }
      scope :movimento, -> { where(condition_type: "movimento") }

      def to_h
        {
          id: id,
          name: name,
          description: description,
          effects: effects,
          condition_type: condition_type,
          escalates_to: escalates_to
        }.compact
      end
    end
  end
end
