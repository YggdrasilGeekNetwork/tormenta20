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
    #   t.rows      # => [["1", "50", ...], ...]
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
    #   @return [Array<Array>] Table rows, each an array of string values
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
          rows: rows || []
        }.compact
      end
    end
  end
end
