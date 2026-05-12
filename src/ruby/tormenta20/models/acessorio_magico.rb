# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Magic accessory items (rings, amulets, cloaks, etc.) with passive and active effects.
    class AcessorioMagico < Base
      self.table_name = "acessorios_magicos"

      scope :menores, -> { where(categoria: "menor") }
      scope :medios,  -> { where(categoria: "medio") }
      scope :maiores, -> { where(categoria: "maior") }

      def efeito
        raw = read_attribute(:efeito)
        return {} if raw.blank?

        raw.is_a?(Hash) ? raw : JSON.parse(raw)
      rescue JSON::ParserError
        {}
      end
    end
  end
end
