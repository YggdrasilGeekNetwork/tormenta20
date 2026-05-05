# frozen_string_literal: true

module Tormenta20
  module Rules
    # PM cap rules for variable-cost abilities (Tormenta20 core rules).
    #
    # Rule: the PM spent on a single use of a variable-cost ability cannot exceed
    # the character's level in the class that provides it. If the ability comes
    # from a race, origin, or general power (no class source), the cap equals the
    # total character level.
    module PmCap
      # Returns the PM cap for a variable-cost ability.
      #
      # @param source_class [String, nil] name of the class that provides the
      #   ability (e.g. "arcanista"), or nil for race/origin/general powers
      # @param class_level [Integer, nil] character's level in that class
      # @param character_level [Integer] total character level (used as fallback)
      # @return [Integer]
      def self.for_ability(source_class:, class_level:, character_level:)
        return character_level if source_class.nil? || class_level.nil?

        class_level
      end
    end
  end
end
