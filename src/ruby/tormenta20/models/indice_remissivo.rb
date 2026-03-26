# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Entrada do índice remissivo de um livro.
    #
    # Cada linha representa um termo do índice associado a uma página.
    # Os campos +tabela+ e +registro_id+ são opcionais e preenchidos quando
    # o termo é vinculado a um registro concreto de outra tabela da gem.
    #
    # @example Buscar página de "Guerreiro" no T20 EJA
    #   Tormenta20::Models::IndiceRemissivo
    #     .where(livro_id: "t20_eja", tabela: "classes", registro_id: "guerreiro")
    #     .pluck(:pagina)
    #
    # @example Buscar todas as entradas de um livro que mencionam "Magia"
    #   Tormenta20::Models::IndiceRemissivo
    #     .where(livro_id: "t20_eja")
    #     .where("termo LIKE ?", "%Magia%")
    class IndiceRemissivo < Base
      self.table_name = "indice_remissivo"
      self.primary_key = "id"

      belongs_to :livro,
                 class_name: "Tormenta20::Models::Livro",
                 foreign_key: "livro_id"

      validates :livro_id, presence: true
      validates :termo,    presence: true
      validates :pagina,   presence: true, numericality: { only_integer: true, greater_than: 0 }

      # Scopes
      scope :do_livro,      ->(livro_id)    { where(livro_id: livro_id) }
      scope :para_tabela,   ->(tabela)      { where(tabela: tabela) }
      scope :associados,                    -> { where.not(registro_id: nil) }
      scope :nao_associados,                -> { where(registro_id: nil) }
      scope :buscar_termo,  ->(q)           { where("termo LIKE ?", "%#{q}%") }

      def to_h
        {
          id:          id,
          livro_id:    livro_id,
          termo:       termo,
          pagina:      pagina,
          tabela:      tabela,
          registro_id: registro_id
        }.compact
      end

      def associado?
        registro_id.present?
      end
    end
  end
end
