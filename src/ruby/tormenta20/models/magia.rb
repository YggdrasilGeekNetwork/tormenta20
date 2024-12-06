# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Magia (Spell) in Tormenta20.
    #
    # Spells are categorized by type (arcane, divine, universal), circle (1-5),
    # and school (abjuration, evocation, etc.).
    #
    # @example Find all arcane spells
    #   Magia.arcanas
    #
    # @example Find 3rd circle evocation spells
    #   Magia.by_circle("3").by_school("evoc")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "bola_de_fogo")
    # @!attribute [rw] name
    #   @return [String] Spell name (e.g., "Bola de Fogo")
    # @!attribute [rw] type
    #   @return [String] Spell type: "arcana", "divina", or "universal"
    # @!attribute [rw] circle
    #   @return [String] Spell circle (1-5)
    # @!attribute [rw] school
    #   @return [String] Magic school code (abjur, adiv, conv, encan, evoc, ilus, necro, trans)
    # @!attribute [rw] execution
    #   @return [String] Casting time
    # @!attribute [rw] range
    #   @return [String] Spell range
    # @!attribute [rw] duration
    #   @return [String] Spell duration
    # @!attribute [rw] description
    #   @return [String] Full spell description
    class Magia < Base
      self.table_name = "magias"
      self.inheritance_column = nil

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :type, presence: true, inclusion: { in: %w[arcana divina universal] }
      validates :circle, presence: true
      validates :school, presence: true, inclusion: { in: %w[abjur adiv conv encan evoc ilus necro trans] }
      validates :execution, presence: true
      validates :range, presence: true
      validates :duration, presence: true
      validates :description, presence: true

      # @!group Scopes

      # @!method arcanas
      #   Filter arcane spells only.
      #   @return [ActiveRecord::Relation<Magia>]
      scope :arcanas, -> { where(type: "arcana") }

      # @!method divinas
      #   Filter divine spells only.
      #   @return [ActiveRecord::Relation<Magia>]
      scope :divinas, -> { where(type: "divina") }

      # @!method universais
      #   Filter universal spells only.
      #   @return [ActiveRecord::Relation<Magia>]
      scope :universais, -> { where(type: "universal") }

      # @!method by_circle(circle)
      #   Filter spells by circle.
      #   @param circle [String, Integer] The spell circle (1-5)
      #   @return [ActiveRecord::Relation<Magia>]
      scope :by_circle, ->(circle) { where(circle: circle.to_s) }

      # @!method by_school(school)
      #   Filter spells by magic school.
      #   @param school [String] School code (abjur, adiv, conv, encan, evoc, ilus, necro, trans)
      #   @return [ActiveRecord::Relation<Magia>]
      scope :by_school, ->(school) { where(school: school) }

      # @!method by_type(type)
      #   Filter spells by type.
      #   @param type [String] Spell type (arcana, divina, universal)
      #   @return [ActiveRecord::Relation<Magia>]
      scope :by_type, ->(type) { where(type: type) }

      # @!endgroup

      class << self
        # Get all spells.
        #
        # @return [ActiveRecord::Relation<Magia>] All spells
        def todas
          all
        end

        # Get divine spells (alias for divinas scope).
        #
        # @return [ActiveRecord::Relation<Magia>] Divine spells
        def divinas_list
          divinas
        end

        # Get arcane spells (alias for arcanas scope).
        #
        # @return [ActiveRecord::Relation<Magia>] Arcane spells
        def arcanas_list
          arcanas
        end

        # Get universal spells (alias for universais scope).
        #
        # @return [ActiveRecord::Relation<Magia>] Universal spells
        def universais_list
          universais
        end

        # Find spells by circle (Portuguese alias).
        #
        # @param circle [String, Integer] The spell circle
        # @return [ActiveRecord::Relation<Magia>] Spells of the given circle
        def do_circulo(circle)
          by_circle(circle)
        end

        # Find spells by school (Portuguese alias).
        #
        # @param school [String] The magic school code
        # @return [ActiveRecord::Relation<Magia>] Spells of the given school
        def da_escola(school)
          by_school(school)
        end
      end

      # Get target information as a structured hash.
      #
      # @return [Hash] Target info with :amount, :up_to, and :type keys
      def target_info
        {
          amount: target_amount,
          up_to: target_up_to&.positive?,
          type: target_type
        }
      end

      # Get effect details as a structured hash.
      #
      # @return [Hash, nil] Effect details or nil if no effect info exists
      def effect_details_info
        return nil unless effect_shape || effect_dimention || effect_size

        {
          shape: effect_shape,
          dimention: effect_dimention,
          size: effect_size,
          other_details: effect_other_details
        }.compact
      end

      # Get resistance information as a structured hash.
      #
      # @return [Hash, nil] Resistance info or nil if no resistance exists
      def resistence_info
        return nil unless resistence_effect || resistence_skill

        {
          effect: resistence_effect,
          skill: resistence_skill
        }.compact
      end

      # Get extra costs as a structured hash.
      #
      # @return [Hash, nil] Extra costs or nil if no extra costs exist
      def extra_costs_info
        return nil unless extra_costs_material_component

        {
          material_component: extra_costs_material_component,
          material_component_cost: extra_costs_material_cost,
          pm_debuff: extra_costs_pm_debuff,
          pm_sacrifice: extra_costs_pm_sacrifice
        }.compact
      end

      # Convert spell to a hash representation.
      #
      # @return [Hash] Hash with all spell attributes
      def to_h
        {
          id: id,
          name: name,
          type: type,
          circle: circle,
          school: school,
          execution: execution,
          execution_details: execution_details,
          range: range,
          target: target_info,
          effect: effect,
          effect_details: effect_details_info,
          area_effect: area_effect,
          counterspell: counterspell,
          duration: duration,
          duration_details: duration_details,
          resistence: resistence_info,
          extra_costs: extra_costs_info,
          description: description,
          enhancements: enhancements,
          effects: effects
        }.compact
      end

      # @api private
      def method_missing(method_name, *args)
        return super unless respond_to_missing?(method_name)

        send(method_name.to_s.gsub("?", ""), *args)
      end

      # @api private
      def respond_to_missing?(method_name, include_private = false)
        attributes.key?(method_name.to_s) || super
      end
    end
  end
end
