# frozen_string_literal: true

module Tormenta20
  module Concerns
    # Mixin that gives any gem model access to its book/page reference.
    #
    # Methods are lazy-loaded: the database is queried on the first call
    # and the result is memoized for the lifetime of the instance.
    #
    # @example
    #   guerreiro = Tormenta20.classes.find("guerreiro")
    #   guerreiro.book_reference  # => "T20 - EJA, p. 56"
    #   guerreiro.page            # => 56
    #   guerreiro.book            # => "T20 - EJA"
    #   guerreiro.full_book       # => "Tormenta 20 - Edição Jogo do Ano"
    module BookReferenceable
      # "T20 - EJA, p. 215" — nil se não houver entrada no índice.
      def book_reference
        entry = _indice_entry
        return nil unless entry

        "#{entry.livro.nome_curto}, p. #{entry.pagina}"
      end

      # Número da página (Integer) — nil se não indexado.
      def page
        _indice_entry&.pagina
      end

      # Nome curto do livro (String) — nil se não indexado.
      def book
        _indice_entry&.livro&.nome_curto
      end

      # Nome completo do livro (String) — nil se não indexado.
      def full_book
        _indice_entry&.livro&.nome
      end

      private

      def _indice_entry
        # Memoize por instância; reset se o id mudar.
        return @_indice_entry if defined?(@_indice_entry)

        @_indice_entry = Models::IndiceRemissivo
                         .includes(:livro)
                         .find_by(tabela: self.class.table_name, registro_id: id.to_s)
      end
    end
  end
end
