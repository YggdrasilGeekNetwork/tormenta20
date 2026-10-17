# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # A Cômodo (headquarters room) in Tormenta20.
    #
    # A catalog of rooms a group can build inside their base, each granting a
    # passive bonus to residents. Some have a +prerequisito+ (e.g. another cômodo,
    # or a minimum porte). Only catalog data lives here — see {BaseTipo}.
    #
    # @example
    #   Tormenta20.comodos.find("biblioteca")
    class Comodo < Base
      self.table_name = "comodos"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      def to_h
        {
          id: id,
          name: name,
          description: description,
          effects: effects || [],
          prerequisito: prerequisito
        }.compact
      end
    end
  end
end
