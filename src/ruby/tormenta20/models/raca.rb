# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # ActiveRecord model for raças (playable races).
    #
    # @example Find all races
    #   Raca.all
    #
    # @example Get the attribute bonus for a specific attribute
    #   Raca.find_by(id: "elfo").attribute_bonus_for("DES")  # => 2
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g. +"humano"+, +"elfo"+)
    # @!attribute [rw] name
    #   @return [String] Race name
    # @!attribute [rw] description
    #   @return [String, nil] Lore description
    # @!attribute [rw] size
    #   @return [String] Size category — see {SIZES}
    # @!attribute [rw] movement
    #   @return [Integer] Base movement speed in metres
    # @!attribute [rw] vision
    #   @return [String] Vision type — see {VISIONS}
    # @!attribute [rw] vision_range
    #   @return [Integer, nil] Range of special vision in metres, or +nil+ for normal vision
    # @!attribute [rw] attribute_bonuses
    #   @return [Hash{String => Integer}] Map of attribute key to bonus value
    # @!attribute [rw] skill_bonuses
    #   @return [Array] Skill bonus descriptors
    # @!attribute [rw] racial_abilities
    #   @return [Array<String>] IDs of abilities all members of this race possess
    # @!attribute [rw] chosen_abilities_amount
    #   @return [Integer] Number of abilities the player selects at character creation
    # @!attribute [rw] available_chosen_abilities
    #   @return [Array] Pool of ability IDs to choose from
    class Raca < Base
      self.table_name = "racas"

      SIZES = %w[minúsculo pequeno médio grande].freeze
      VISIONS = %w[normal baixa_luminosidade visao_no_escuro].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :size, inclusion: { in: SIZES }
      validates :movement, numericality: { only_integer: true, greater_than: 0 }

      # Returns the racial attribute bonus for the given attribute key.
      # @param attribute [String, Symbol] Attribute key (e.g. +"DES"+, +"FOR"+)
      # @return [Integer] Bonus value, or +0+ if no bonus exists
      def attribute_bonus_for(attribute)
        attribute_bonuses&.dig(attribute.to_s) || 0
      end

      # @return [Boolean] +true+ if the race is Tiny size
      def minusculo?
        size == "minúsculo"
      end

      # @return [Boolean] +true+ if the race is Small size
      def pequeno?
        size == "pequeno"
      end

      # @return [Boolean] +true+ if the race is Large size
      def grande?
        size == "grande"
      end

      # @return [Boolean] +true+ if the race has darkvision
      def visao_no_escuro?
        vision == "visao_no_escuro"
      end

      def to_h
        {
          id: id,
          name: name,
          description: description,
          size: size,
          movement: movement,
          vision: vision,
          vision_range: vision_range,
          attribute_bonuses: attribute_bonuses || {},
          skill_bonuses: skill_bonuses || [],
          racial_abilities: racial_abilities || [],
          chosen_abilities_amount: chosen_abilities_amount || 0,
          available_chosen_abilities: available_chosen_abilities || []
        }.compact
      end
    end
  end
end
