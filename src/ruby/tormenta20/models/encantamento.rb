# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing an Encantamento (Enchantment) in Tormenta20.
    #
    # Enchantments are magical properties applied to permanent magic items
    # (weapons, armor, shields). They are distinct from Melhorias (enhancements),
    # which apply to superior items.
    #
    # @example Find all weapon enchantments
    #   Tormenta20.encantamentos.where(categoria: "arma")
    #
    # @example Find all armor/shield enchantments
    #   Tormenta20.encantamentos.where(categoria: "armadura_escudo")
    class Encantamento < Base
      self.table_name = "encantamentos"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :categoria, presence: true, inclusion: { in: %w[arma armadura_escudo] }

      scope :armas, -> { where(categoria: "arma") }
      scope :armaduras_escudos, -> { where(categoria: "armadura_escudo") }
      scope :escudo_only, -> { where(escudo_only: true) }

      def to_h
        {
          id: id,
          name: name,
          description: description,
          categoria: categoria,
          escudo_only: escudo_only == 1,
          conta_como_dois: conta_como_dois == 1,
          prerequisitos: prerequisitos,
          efeito: efeito
        }.compact
      end
    end
  end
end
