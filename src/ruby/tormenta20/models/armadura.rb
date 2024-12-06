# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing an Armadura (Armor) in Tormenta20.
    #
    # Armors provide defense bonuses but may impose armor penalties.
    # They are categorized as light (leve) or heavy (pesada).
    #
    # @example Find all light armors
    #   Tormenta20.armaduras.leves
    #
    # @example Find heavy armors sorted by defense
    #   Tormenta20.armaduras.pesadas.order(defense_bonus: :desc)
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "couro")
    # @!attribute [rw] name
    #   @return [String] Armor name in Portuguese
    # @!attribute [rw] category
    #   @return [String] Armor category: "leve" or "pesada"
    # @!attribute [rw] price
    #   @return [String] Price in Tormenta currency
    # @!attribute [rw] defense_bonus
    #   @return [Integer] Defense bonus provided by the armor
    # @!attribute [rw] armor_penalty
    #   @return [Integer] Armor penalty for skill checks
    # @!attribute [rw] weight
    #   @return [String] Weight in slots/spaces
    # @!attribute [rw] properties
    #   @return [Array<String>] Special armor properties
    # @!attribute [rw] description
    #   @return [String, nil] Optional description
    class Armadura < Base
      self.table_name = "armaduras"

      # @return [Array<String>] Valid armor categories
      CATEGORIES = %w[leve pesada].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :category, presence: true, inclusion: { in: CATEGORIES }
      validates :defense_bonus, presence: true

      # @!method leves
      #   Filter light armors only.
      #   @return [ActiveRecord::Relation<Armadura>]
      scope :leves, -> { where(category: "leve") }

      # @!method pesadas
      #   Filter heavy armors only.
      #   @return [ActiveRecord::Relation<Armadura>]
      scope :pesadas, -> { where(category: "pesada") }

      # @!method by_category(category)
      #   Filter armors by category.
      #   @param category [String] Category: "leve" or "pesada"
      #   @return [ActiveRecord::Relation<Armadura>]
      scope :by_category, ->(c) { where(category: c) }

      # Check if this is a light armor.
      #
      # @return [Boolean] true if armor category is "leve"
      def leve?
        category == "leve"
      end

      # Check if this is a heavy armor.
      #
      # @return [Boolean] true if armor category is "pesada"
      def pesada?
        category == "pesada"
      end

      # Convert the armor to a hash representation.
      #
      # @return [Hash] Hash with all armor attributes (nil values excluded)
      def to_h
        {
          id: id,
          name: name,
          category: category,
          price: price,
          defense_bonus: defense_bonus,
          armor_penalty: armor_penalty,
          weight: weight,
          properties: properties,
          description: description
        }.compact
      end
    end
  end
end
