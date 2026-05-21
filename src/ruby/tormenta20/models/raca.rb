# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # ActiveRecord model for raças (playable races).
    class Raca < Base
      self.table_name = "racas"

      SIZES = %w[minúsculo pequeno médio grande].freeze
      VISIONS = %w[normal baixa_luminosidade visao_no_escuro].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :size, inclusion: { in: SIZES }
      validates :movement, numericality: { only_integer: true, greater_than: 0 }

      def attribute_bonus_for(attribute)
        attribute_bonuses&.dig(attribute.to_s) || 0
      end

      def minusculo?
        size == "minúsculo"
      end

      def pequeno?
        size == "pequeno"
      end

      def grande?
        size == "grande"
      end

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
