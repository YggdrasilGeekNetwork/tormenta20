# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Magic accessory items (rings, amulets, cloaks, etc.) with passive and active effects.
    #
    # @example
    #   AcessorioMagico.menores.all
    #   AcessorioMagico.find_by(id: "anel_de_protecao").efeito
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier
    # @!attribute [rw] name
    #   @return [String] Item name
    # @!attribute [rw] categoria
    #   @return [String] Power tier: +"menor"+, +"medio"+, or +"maior"+
    # @!attribute [rw] preco
    #   @return [Integer, nil] Price in tibares
    # @!attribute [rw] roll_min
    #   @return [Integer, nil] Minimum roll on random loot table
    # @!attribute [rw] roll_max
    #   @return [Integer, nil] Maximum roll on random loot table
    # @!attribute [rw] description
    #   @return [String, nil] Item description
    class AcessorioMagico < Base
      self.table_name = "acessorios_magicos"

      # @!group Scopes
      # @!method menores
      #   @return [ActiveRecord::Relation] Minor-tier accessories
      scope :menores, -> { where(categoria: "menor") }
      # @!method medios
      #   @return [ActiveRecord::Relation] Medium-tier accessories
      scope :medios,  -> { where(categoria: "medio") }
      # @!method maiores
      #   @return [ActiveRecord::Relation] Major-tier accessories
      scope :maiores, -> { where(categoria: "maior") }
      # @!endgroup

      # Returns the parsed effect hash, handling both raw JSON strings and pre-parsed hashes.
      # @return [Hash] Effect data, or +{}+ on parse failure
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
