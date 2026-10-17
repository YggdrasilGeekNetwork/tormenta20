# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Named specific magic weapons from Tormenta20 (Cap. 8, Tabela 8-9).
    #
    # @example
    #   Tormenta20.armas_magicas.find("cajado_do_poder")
    #   Tormenta20.armas_magicas.order(:preco)
    class ArmaMagicaEspecifica < Base
      self.table_name = "armas_magicas_especificas"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      scope :by_base, ->(w) { where(base_weapon: w) }

      def to_h
        {
          id: id,
          name: name,
          base_weapon: base_weapon,
          preco: preco,
          description: description,
          effects: effects
        }.compact
      end
    end
  end
end
