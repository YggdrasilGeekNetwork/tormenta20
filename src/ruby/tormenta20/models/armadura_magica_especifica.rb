# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Named specific magic armors and shields from Tormenta20 (Cap. 8, Tabela 8-11).
    #
    # @example
    #   Tormenta20.armaduras_magicas.where(subtipo: "escudo")
    #   Tormenta20.armaduras_magicas.find("cota_elfica")
    class ArmaduraMagicaEspecifica < Base
      self.table_name = "armaduras_magicas_especificas"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :subtipo, inclusion: { in: %w[armadura escudo] }

      scope :armaduras, -> { where(subtipo: "armadura") }
      scope :escudos,   -> { where(subtipo: "escudo") }

      def to_h
        {
          id: id,
          name: name,
          subtipo: subtipo,
          base_item: base_item,
          preco: preco,
          description: description,
          effects: effects
        }.compact
      end
    end
  end
end
