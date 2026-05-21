# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Consumable magic items: potions, oils, and grenades.
    class Pocao < Base
      self.table_name = "pocoes"

      scope :menores,  -> { where(categoria: "menor") }
      scope :medias,   -> { where(categoria: "medio") }
      scope :maiores,  -> { where(categoria: "maior") }
      scope :pocoes,   -> { where(subtipo: "pocao") }
      scope :oleos,    -> { where(subtipo: "oleo") }
      scope :granadas, -> { where(subtipo: "granada") }
    end
  end
end
