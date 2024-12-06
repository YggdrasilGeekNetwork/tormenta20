# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Classe (Character Class) in Tormenta20.
    #
    # Classes define the character's abilities, proficiencies, and progression.
    #
    # @example Find all spellcasting classes
    #   Classe.conjuradores
    #
    # @example Get class HP information
    #   guerreiro = Classe.find("guerreiro")
    #   guerreiro.initial_hp    # => 20
    #   guerreiro.hp_per_level  # => 5
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "guerreiro")
    # @!attribute [rw] name
    #   @return [String] Class name (e.g., "Guerreiro")
    # @!attribute [rw] hit_points
    #   @return [Hash] Hit points data with "initial" and "per_level" keys
    # @!attribute [rw] mana_points
    #   @return [Hash] Mana points data with "per_level" key
    # @!attribute [rw] skills
    #   @return [Hash] Skills data with "mandatory", "choose_amount", "choose_from" keys
    # @!attribute [rw] proficiencies
    #   @return [Hash] Proficiencies with "weapons", "armors", "shields" keys
    # @!attribute [rw] spellcasting
    #   @return [Hash, nil] Spellcasting info or nil if class cannot cast spells
    class Classe < Base
      self.table_name = "classes"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      # @!method conjuradores
      #   Filter classes that can cast spells.
      #   @return [ActiveRecord::Relation<Classe>]
      scope :conjuradores, -> { where.not(spellcasting: nil) }

      # Get initial hit points for this class.
      #
      # @return [Integer] Initial HP at level 1
      def initial_hp
        hit_points&.dig("initial") || 0
      end

      # Get hit points gained per level.
      #
      # @return [Integer] HP gained each level
      def hp_per_level
        hit_points&.dig("per_level") || 0
      end

      # Get mana points gained per level.
      #
      # @return [Integer] MP gained each level
      def mp_per_level
        mana_points&.dig("per_level") || 0
      end

      # Get mandatory skills for this class.
      #
      # @return [Array<String>] List of mandatory skill names
      def mandatory_skills
        skills&.dig("mandatory") || []
      end

      # Get number of skills to choose from available list.
      #
      # @return [Integer] Number of skills to choose
      def choose_skills_amount
        skills&.dig("choose_amount") || 0
      end

      # Get skills available to choose from.
      #
      # @return [Array<String>] List of available skill names
      def available_skills
        skills&.dig("choose_from") || []
      end

      # Get weapon proficiencies for this class.
      #
      # @return [Array<String>] List of weapon categories (e.g., ["simples", "marciais"])
      def weapon_proficiencies
        proficiencies&.dig("weapons") || []
      end

      # Get armor proficiencies for this class.
      #
      # @return [Array<String>] List of armor categories (e.g., ["leves", "pesadas"])
      def armor_proficiencies
        proficiencies&.dig("armors") || []
      end

      # Check if class has shield proficiency.
      #
      # @return [Boolean] true if proficient with shields
      def shield_proficiency?
        proficiencies&.dig("shields") || false
      end

      # Check if this class can cast spells.
      #
      # @return [Boolean] true if class has spellcasting ability
      def conjurador?
        !spellcasting.nil?
      end

      # Convert class to a hash representation.
      #
      # @return [Hash] Hash with all class attributes
      def to_h
        {
          id: id,
          name: name,
          hit_points: hit_points,
          mana_points: mana_points,
          skills: skills,
          proficiencies: proficiencies,
          abilities: abilities,
          powers: powers,
          progression: progression,
          spellcasting: spellcasting
        }.compact
      end
    end
  end
end
