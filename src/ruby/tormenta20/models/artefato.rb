# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Artifacts — unique, extremely powerful magic items from Tormenta20 (Cap. 8, pp. 350–353).
    #
    # @example
    #   Tormenta20.artefatos.all
    #   Tormenta20.artefatos.find("espada_deus")
    class Artefato < Base
      self.table_name = "artefatos"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      def to_h
        { id: id, name: name, description: description, effects: effects }.compact
      end
    end
  end
end
