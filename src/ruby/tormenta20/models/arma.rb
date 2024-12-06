# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing an Arma (Weapon) in Tormenta20.
    #
    # Weapons are categorized by type (simple, martial, exotic, firearm)
    # and can be either melee or ranged.
    #
    # @example Find all martial weapons
    #   Tormenta20.armas.marciais
    #
    # @example Find ranged weapons
    #   Tormenta20.armas.ranged
    #
    # @example Find weapons by damage type
    #   Tormenta20.armas.by_damage_type("corte")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "espada_longa")
    # @!attribute [rw] name
    #   @return [String] Weapon name in Portuguese
    # @!attribute [rw] category
    #   @return [String] Weapon category: "simples", "marciais", "exoticas", or "fogo"
    # @!attribute [rw] price
    #   @return [String] Price in Tormenta currency
    # @!attribute [rw] damage
    #   @return [String] Damage dice (e.g., "1d8")
    # @!attribute [rw] damage_type
    #   @return [String] Type of damage: "corte", "perfuracao", "impacto"
    # @!attribute [rw] critical
    #   @return [String] Critical hit modifier (e.g., "19/x2")
    # @!attribute [rw] range
    #   @return [String, nil] Range for ranged weapons, nil for melee
    # @!attribute [rw] weight
    #   @return [String] Weight in slots/spaces
    # @!attribute [rw] properties
    #   @return [Array<String>] Special weapon properties
    # @!attribute [rw] description
    #   @return [String, nil] Optional description
    class Arma < Base
      self.table_name = "armas"

      # @return [Array<String>] Valid weapon categories
      CATEGORIES = %w[simples marciais exoticas fogo].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :category, presence: true, inclusion: { in: CATEGORIES }

      # @!method simples
      #   Filter simple weapons only.
      #   @return [ActiveRecord::Relation<Arma>]
      scope :simples, -> { where(category: "simples") }

      # @!method marciais
      #   Filter martial weapons only.
      #   @return [ActiveRecord::Relation<Arma>]
      scope :marciais, -> { where(category: "marciais") }

      # @!method exoticas
      #   Filter exotic weapons only.
      #   @return [ActiveRecord::Relation<Arma>]
      scope :exoticas, -> { where(category: "exoticas") }

      # @!method fogo
      #   Filter firearms only.
      #   @return [ActiveRecord::Relation<Arma>]
      scope :fogo, -> { where(category: "fogo") }

      # @!method by_category(category)
      #   Filter weapons by category.
      #   @param category [String] Category to filter by
      #   @return [ActiveRecord::Relation<Arma>]
      scope :by_category, ->(c) { where(category: c) }

      # @!method by_damage_type(type)
      #   Filter weapons by damage type.
      #   @param type [String] Damage type: "corte", "perfuracao", or "impacto"
      #   @return [ActiveRecord::Relation<Arma>]
      scope :by_damage_type, ->(t) { where(damage_type: t) }

      # @!method ranged
      #   Filter ranged weapons only (weapons with a range value).
      #   @return [ActiveRecord::Relation<Arma>]
      scope :ranged, -> { where.not(range: nil) }

      # @!method melee
      #   Filter melee weapons only (weapons without a range value).
      #   @return [ActiveRecord::Relation<Arma>]
      scope :melee, -> { where(range: nil) }

      # Check if this weapon is ranged.
      #
      # @return [Boolean] true if the weapon has a range value
      def ranged?
        !range.nil?
      end

      # Convert the weapon to a hash representation.
      #
      # @return [Hash] Hash with all weapon attributes (nil values excluded)
      def to_h
        {
          id: id,
          name: name,
          category: category,
          price: price,
          damage: damage,
          damage_type: damage_type,
          critical: critical,
          range: range,
          weight: weight,
          properties: properties,
          description: description
        }.compact
      end
    end
  end
end
