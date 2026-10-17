# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # A Complicação (character complication) in Tormenta20.
    #
    # Chosen at character creation: the player accepts a mechanical drawback ({#effects})
    # in exchange for freely picking any one general power whose prerequisites they meet
    # (not a fixed grant tied to the complication — the gem doesn't model that choice,
    # it belongs to the consumer's character-creation flow). +categoria+ is +"geral"+ for
    # complications any character can take, or a class id (e.g. +"guerreiro"+) for
    # complications specific to that class.
    #
    # @example
    #   Tormenta20.complicacoes.gerais
    #   Tormenta20.complicacoes.by_categoria("guerreiro")
    class Complicacao < Base
      self.table_name = "complicacoes"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :categoria, presence: true

      scope :gerais, -> { where(categoria: "geral") }
      scope :by_categoria, ->(categoria) { where(categoria: categoria) }

      def to_h
        {
          id: id,
          name: name,
          description: description,
          categoria: categoria,
          effects: effects || []
        }.compact
      end
    end
  end
end
