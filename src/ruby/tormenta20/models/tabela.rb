# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Tabela (Reference Table) in Tormenta20.
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
