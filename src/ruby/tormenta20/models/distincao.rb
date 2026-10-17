# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Model representing a Distinção in Tormenta20.
    #
    # A distinction ties a character to an organization, philosophy, or people
    # of Arton. It has three parts: admissão (narrative requirement), marca
    # (an ability granted automatically on admission), and a set of exclusive
    # powers. The powers themselves live in {Poder} (+type: "poder_distincao"+,
    # +distincao_id+ pointing back here) — not duplicated on this model.
    #
    # @example Find a distinction and its powers
    #   Tormenta20.distincoes.find("cavaleiro_do_corvo")
    #   Tormenta20.poderes.where(distincao_id: "cavaleiro_do_corvo")
    class Distincao < Base
      self.table_name = "distincoes"

      has_many :poderes, class_name: "Tormenta20::Models::Poder"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true

      def to_h
        {
          id: id,
          name: name,
          description: description,
          admissao: admissao,
          marca_nome: marca_nome,
          marca_descricao: marca_descricao,
          nivel_minimo: nivel_minimo
        }.compact
      end
    end
  end
end
