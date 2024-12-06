# frozen_string_literal: true

require "active_record"
require "json"

module Tormenta20
  module Models
    # Model representing a Poder (Power/Ability) in Tormenta20.
    #
    # Powers can be unique origin abilities, deity-granted powers, Tormenta powers, etc.
    #
    # @example Find deity-granted powers
    #   Poder.poderes_concedidos
    #
    # @example Find powers by type
    #   Poder.by_type("poder_tormenta")
    #
    # @!attribute [rw] id
    #   @return [String] Unique identifier
    # @!attribute [rw] name
    #   @return [String] Power name
    # @!attribute [rw] type
    #   @return [String] Power type (see TYPES constant)
    # @!attribute [rw] description
    #   @return [String] Power description
    # @!attribute [rw] effects
    #   @return [Array] Power effects
    # @!attribute [rw] prerequisites
    #   @return [Array] Prerequisites to acquire this power
    # @!attribute [rw] origin_id
    #   @return [String, nil] Associated origin ID (for unique origin powers)
    # @!attribute [rw] deities
    #   @return [Array<String>] Deities that grant this power
    class Poder < Base
      self.table_name = "poderes"
      self.inheritance_column = nil

      # Valid power types.
      #
      # @return [Array<String>] List of valid type values
      TYPES = %w[
        habilidade_unica_origem
        poder_concedido
        poder_tormenta
        poder_classe
        poder_geral
        poder_combate
        poder_destino
        poder_magia
      ].freeze

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :type, presence: true, inclusion: { in: TYPES }

      # @!group Scopes

      # @!method habilidades_unicas
      #   Filter unique origin abilities.
      #   @return [ActiveRecord::Relation<Poder>]
      scope :habilidades_unicas, -> { where(type: "habilidade_unica_origem") }

      # @!method poderes_concedidos
      #   Filter deity-granted powers.
      #   @return [ActiveRecord::Relation<Poder>]
      scope :poderes_concedidos, -> { where(type: "poder_concedido") }

      # @!method poderes_tormenta
      #   Filter Tormenta powers.
      #   @return [ActiveRecord::Relation<Poder>]
      scope :poderes_tormenta, -> { where(type: "poder_tormenta") }

      # @!method poderes_classe
      #   Filter class powers.
      #   @return [ActiveRecord::Relation<Poder>]
      scope :poderes_classe, -> { where(type: "poder_classe") }

      # @!method poderes_gerais
      #   Filter general powers.
      #   @return [ActiveRecord::Relation<Poder>]
      scope :poderes_gerais, -> { where(type: "poder_geral") }

      # @!method by_type(type)
      #   Filter powers by type.
      #   @param type [String] Power type
      #   @return [ActiveRecord::Relation<Poder>]
      scope :by_type, ->(t) { where(type: t) }

      # @!method by_origin(origin_id)
      #   Filter powers by associated origin.
      #   @param origin_id [String] Origin ID
      #   @return [ActiveRecord::Relation<Poder>]
      scope :by_origin, ->(origin_id) { where(origin_id: origin_id) }

      # @!method by_deity(deity_id)
      #   Filter powers granted by a specific deity.
      #   @param deity_id [String] Deity ID
      #   @return [ActiveRecord::Relation<Poder>]
      scope :by_deity, ->(deity_id) { where("json_extract(deities, '$') LIKE ?", "%#{deity_id}%") }

      # @!endgroup

      # Convert power to a hash representation.
      #
      # @return [Hash] Hash with all power attributes
      def to_h
        {
          id: id,
          name: name,
          type: type,
          description: description,
          effects: effects,
          prerequisites: prerequisites,
          origin_id: origin_id,
          deities: deities
        }.compact
      end
    end
  end
end
