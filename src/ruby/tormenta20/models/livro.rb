# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # ActiveRecord model for livros (sourcebooks).
    #
    # Livros are the target of {IndiceRemissivo} entries, which link
    # game terms to page numbers in a specific book.
    #
    # @example
    #   Livro.find_by(id: "t20_eja").nome_curto  # => "T20 - EJA"
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier (e.g. +"t20_eja"+)
    # @!attribute [rw] nome
    #   @return [String] Full book title
    # @!attribute [rw] nome_curto
    #   @return [String] Short reference abbreviation (e.g. +"T20 - EJA"+)
    class Livro < Base
      self.table_name = "livros"

      has_many :indice_remissivo_entries,
               class_name: "Tormenta20::Models::IndiceRemissivo",
               foreign_key: "livro_id",
               dependent: :destroy

      validates :id,         presence: true, uniqueness: true
      validates :nome,       presence: true
      validates :nome_curto, presence: true

      def to_h
        {
          id: id,
          nome: nome,
          nome_curto: nome_curto
        }
      end
    end
  end
end
