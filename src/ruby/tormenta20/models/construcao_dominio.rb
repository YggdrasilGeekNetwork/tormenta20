# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # A Construção de Domínio (domain building) in Tormenta20.
    #
    # A catalog of buildings a regent can erect in their domain (Cap. 4 "Domínios"),
    # each with a cost in Lingotes de Ouro (LO) and a mechanical benefit. Only catalog
    # data lives here — an actual domain's characteristics (level, corte, popularidade,
    # buildings erected) are campaign state, not gem content. See also {BaseTipo} for
    # the analogous pattern applied to group headquarters.
    #
    # @example
    #   Tormenta20.construcoes_dominio.by_categoria("religiao")
    class ConstrucaoDominio < Base
      self.table_name = "construcoes_dominio"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :categoria, presence: true, inclusion: { in: %w[nobreza guerra enganacao religiao misticismo] }

      scope :by_categoria, ->(categoria) { where(categoria: categoria) }

      def to_h
        {
          id: id,
          name: name,
          description: description,
          categoria: categoria,
          custo: custo,
          effects: effects || [],
          prerequisito: prerequisito
        }.compact
      end
    end
  end
end
