# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Perícia (Skill) in Tormenta20.
    class Pericia < Base
      self.table_name = "pericias"

      ATRIBUTOS = %w[FOR DES CON INT SAB CAR].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :atributo, inclusion: { in: ATRIBUTOS }

      scope :by_atributo,     ->(attr) { where(atributo: attr) }
      scope :trained_only,    -> { where(trained_only: true) }
      scope :with_armor_penalty, -> { where(armor_penalty: true) }
      scope :resistance_skills, -> { where(resistance_skill: true) }

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

      def trained_only?     = [true, 1].include?(trained_only)
      def armor_penalty?    = [true, 1].include?(armor_penalty)
      def resistance_skill? = [true, 1].include?(resistance_skill)
    end
  end
end
