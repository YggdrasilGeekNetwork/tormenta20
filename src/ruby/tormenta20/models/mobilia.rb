# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # A Mobília (headquarters furniture) in Tormenta20.
    #
    # A catalog of furniture items that can be installed in a {Comodo} to grant an
    # additional bonus. Some are restricted to a specific cômodo (+comodo_alvo+).
    # Only catalog data lives here — see {BaseTipo}.
    #
    # @example
    #   Tormenta20.mobilias.find("bar")
    class Mobilia < Base
      self.table_name = "mobilias"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      def to_h
        {
          id: id,
          name: name,
          description: description,
          effects: effects || [],
          preco: preco,
          comodo_alvo: comodo_alvo
        }.compact
      end
    end
  end
end
