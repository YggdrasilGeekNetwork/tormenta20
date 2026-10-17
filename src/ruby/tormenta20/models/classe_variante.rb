# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Model representing a Classe Variante (variant class) in Tormenta20.
    #
    # A variant class is a specialized version of a base class (e.g. Duelista
    # is a Bucaneiro variant). It is stored as a diff over the base class: the
    # +diffs+ array lists, per level, which base-class abilities are removed
    # and which new ones are added. Consumers must resolve the diff against
    # the base {Classe} record to build the final character sheet.
    #
    # @example
    #   variante = Tormenta20.classes_variantes.find("duelista")
    #   variante.base_classe #=> the Bucaneiro Classe record
    #   variante.diffs       #=> [{ "nivel" => 1, "remove" => [...], "adiciona" => [...] }, ...]
    class ClasseVariante < Base
      self.table_name = "classes_variantes"

      belongs_to :base_classe, class_name: "Tormenta20::Models::Classe", foreign_key: "base_class_id"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :base_class_id, presence: true

      scope :by_base, ->(class_id) { where(base_class_id: class_id) }

      def to_h
        {
          id: id,
          name: name,
          base_class_id: base_class_id,
          description: description,
          diffs: diffs
        }.compact
      end
    end
  end
end
