# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Named magic item tied to a specific deity (Deuses de Arton, Cap. 1).
    #
    # Liturgical items (weapons, armors or accessories) only reach their full
    # potential — or only work at all — in the hands of a devotee of the
    # associated deity. They can span multiple item categories, so `deities`
    # is a JSON array instead of a rigid foreign key.
    #
    # @example
    #   Tormenta20.itens_liturgicos.find("cilicio_vivo")
    #   Tormenta20.itens_liturgicos.by_deity("aharadak")
    class ItemLiturgico < Base
      self.table_name = "itens_liturgicos"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      scope :by_deity, ->(deity_id) { where("json_extract(deities, '$') LIKE ?", "%#{deity_id}%") }
      scope :by_subtipo, ->(s) { where(subtipo: s) }

      def to_h
        {
          id: id,
          name: name,
          deities: deities,
          subtipo: subtipo,
          base_item: base_item,
          classificacao: classificacao,
          preco: preco,
          description: description,
          effects: effects
        }.compact
      end
    end
  end
end
