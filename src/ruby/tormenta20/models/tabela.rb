# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Tabela (reference table) in Tormenta20.
    #
    # Tables store structured tabular data from T20 sourcebooks —
    # random loot tables, encounter tables, progression charts, etc.
    #
    # @example
    #   t = Tabela.find_by(id: "tesouros_por_nd")
    #   t.headers   # => ["ND", "Tibares", ...]
    #   t.rows      # => [{ "ND" => "1", "Tibares" => "50", ... }, ...]
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier
    # @!attribute [rw] name
    #   @return [String] Table name
    # @!attribute [rw] description
    #   @return [String, nil] Description of the table's purpose
    # @!attribute [rw] headers
    #   @return [Array<String>] Column header labels
    # @!attribute [rw] rows
    #   @return [Array<Hash>] Table rows, each a Hash keyed by header
    # @!attribute [rw] dice
    #   @return [String, nil] Dice expression (e.g. +"1d100"+) if this table is rollable via {#roll}
    class Tabela < Base
      self.table_name = "tabelas"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      def to_h
        {
          id: id,
          name: name,
          description: description,
          headers: headers || [],
          rows: rows || [],
          dice: dice
        }.compact
      end

      # @return [Boolean] true if this table has a +dice+ column set and can be rolled on
      def sorteavel?
        dice.present?
      end

      # Rolls the table's dice and returns the matching row (a Hash keyed by header, same
      # shape as {#rows} entries). Assumes the first header's column holds a range string
      # (e.g. +"01-05"+) or a single value (e.g. +"06"+) that the roll falls within.
      #
      # @return [Hash, nil] the matching row, or +nil+ if no row's range matches
      # @raise [RuntimeError] if the table has no +dice+ column set
      def roll
        raise "Tabela '#{id}' não é sorteável (sem coluna dice)" unless sorteavel?

        faces = dice[/\d+\z/].to_i
        result = rand(1..faces)
        range_key = headers.first
        rows.find { |r| self.class.in_range?(r[range_key], result) }
      end

      # @return [Boolean] true if +value+ falls within +range_str+ (e.g. +"01-05"+ or +"06"+)
      def self.in_range?(range_str, value)
        bounds = range_str.to_s.split("-").map(&:to_i)
        bounds << bounds.first if bounds.size == 1
        value.between?(bounds.min, bounds.max)
      end
    end
  end
end
