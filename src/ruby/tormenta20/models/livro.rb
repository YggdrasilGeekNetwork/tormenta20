# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
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
          id:         id,
          nome:       nome,
          nome_curto: nome_curto
        }
      end
    end
  end
end
