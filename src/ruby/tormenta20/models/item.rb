# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing an Item in Tormenta20.
    #
    # Items include general equipment, adventuring gear, tools,
    # and other miscellaneous items.
    #
    # @example Find all items
    #   Tormenta20.itens.all
    #
    # @example Find items by category
    #   Tormenta20.itens.by_category("equipamento")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g., "corda_15m")
    # @!attribute [rw] name
    #   @return [String] Item name in Portuguese
    # @!attribute [rw] category
    #   @return [String, nil] Item category
    # @!attribute [rw] price
    #   @return [String] Price in Tormenta currency
    # @!attribute [rw] weight
    #   @return [String] Weight in slots/spaces
    # @!attribute [rw] description
    #   @return [String, nil] Item description
    # @!attribute [rw] effects
    #   @return [Array<String>, nil] Special effects or uses
    class Item < Base
      self.table_name = "itens"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      # @!method by_category(category)
      #   Filter items by category.
      #   @param category [String] Category to filter by
      #   @return [ActiveRecord::Relation<Item>]
      scope :by_category, ->(c) { where(category: c) }

      # Convert the item to a hash representation.
      #
      # @return [Hash] Hash with all item attributes (nil values excluded)
      def to_h
        {
          id: id,
          name: name,
          category: category,
          price: price,
          weight: weight,
          description: description,
          effects: effects
        }.compact
      end
    end
  end
end
