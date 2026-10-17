# frozen_string_literal: true

module Tormenta20
  module Rules
    # Spell PM cost rules (Tormenta20 core rules, Tabela 4-1: Custo de Magias).
    module SpellCost
      COSTS_BY_CIRCLE = { 1 => 1, 2 => 3, 3 => 6, 4 => 10, 5 => 15 }.freeze

      # Returns the base PM cost for a spell of the given circle.
      #
      # @param circle [String, Integer] the spell's circle (1-5)
      # @return [Integer, nil] PM cost, or nil if the circle is unknown
      def self.for_circle(circle)
        COSTS_BY_CIRCLE[circle.to_i]
      end
    end
  end
end
