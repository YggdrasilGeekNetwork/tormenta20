# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Perícia (Skill) in Tormenta20.
    #
    # @example Find all skills governed by Charisma
    #   Pericia.by_atributo("CAR").all
    #
    # @example Find saving-throw skills
    #   Pericia.resistance_skills.all
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g. +"diplomacia"+)
    # @!attribute [rw] name
    #   @return [String] Skill name
    # @!attribute [rw] atributo
    #   @return [String] Governing attribute abbreviation — see {ATRIBUTOS}
    # @!attribute [rw] trained_only
    #   @return [Integer] 1 if training is required to use the skill, 0 otherwise
    # @!attribute [rw] armor_penalty
    #   @return [Integer] 1 if armor check penalty applies, 0 otherwise
    # @!attribute [rw] resistance_skill
    #   @return [Integer] 1 if this skill is used as a saving throw, 0 otherwise
    # @!attribute [rw] description
    #   @return [String, nil] Skill description
    # @!attribute [rw] uses
    #   @return [Array] Use-case descriptors
    class Pericia < Base
      self.table_name = "pericias"

      # Valid governing attribute abbreviations.
      # @return [Array<String>]
      ATRIBUTOS = %w[FOR DES CON INT SAB CAR].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :atributo, inclusion: { in: ATRIBUTOS }

      # @!group Scopes
      # @!method by_atributo(attr)
      #   @param attr [String] Attribute abbreviation (e.g. +"CAR"+)
      #   @return [ActiveRecord::Relation]
      scope :by_atributo,     ->(attr) { where(atributo: attr) }
      # @!method trained_only
      #   @return [ActiveRecord::Relation] Skills that require training to use
      scope :trained_only,    -> { where(trained_only: true) }
      # @!method with_armor_penalty
      #   @return [ActiveRecord::Relation] Skills affected by armor check penalty
      scope :with_armor_penalty, -> { where(armor_penalty: true) }
      # @!method resistance_skills
      #   @return [ActiveRecord::Relation] Skills used as saving throws
      scope :resistance_skills, -> { where(resistance_skill: true) }
      # @!endgroup

      def to_h
        {
          id: id,
          name: name,
          atributo: atributo,
          trained_only: trained_only?,
          armor_penalty: armor_penalty?,
          resistance_skill: resistance_skill?,
          description: description,
          uses: uses || []
        }.compact
      end

      private

      # @return [Boolean]
      def trained_only?     = [true, 1].include?(trained_only)
      # @return [Boolean]
      def armor_penalty?    = [true, 1].include?(armor_penalty)
      # @return [Boolean]
      def resistance_skill? = [true, 1].include?(resistance_skill)
    end
  end
end
