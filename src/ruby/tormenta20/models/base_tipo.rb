# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # A Tipo de Base (headquarters type) in Tormenta20.
    #
    # Represents the physical nature of a group's headquarters (Esconderijo,
    # Fortificação, Móvel, Residência, Centro de Poder, Empreendimento) and the
    # passive bonuses it grants its residents. Only catalog data lives here — an
    # actual base built by a group (with a chosen type, porte, cômodos, and
    # mobílias) is campaign state, not gem content.
    #
    # @example
    #   Tormenta20.bases_tipos.find("fortificacao")
    class BaseTipo < Base
      self.table_name = "bases_tipos"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      def to_h
        {
          id: id,
          name: name,
          description: description,
          effects: effects || []
        }.compact
      end
    end
  end
end
