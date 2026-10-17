# frozen_string_literal: true

module Tormenta20
  module Concerns
    # Mixin that gives any gem model with a +livro_id+ column access to its
    # source book and a scope to filter by it.
    #
    # Distinct from {BookReferenceable}: that concern looks up a record's page
    # number via the (sparse) printed índice remissivo, while +livro_id+ is
    # the authoritative "book this record was published in" column, present
    # on every content table and defaulting to +"t20_eja"+.
    #
    # @example
    #   Tormenta20.classes.do_livro("t20_eja").all
    #   Tormenta20.classes.first.livro.nome_curto  # => "T20 - EJA"
    module LivroScoped
      extend ActiveSupport::Concern

      included do
        belongs_to :livro, class_name: "Tormenta20::Models::Livro", foreign_key: "livro_id", optional: true

        scope :do_livro, ->(livro_id) { where(livro_id: livro_id) }
      end
    end
  end
end
