# frozen_string_literal: true

require "active_record"

module Tormenta20
  module Models
    # Monster and enemy stat blocks from Tormenta20.
    #
    # @example
    #   Tormenta20.ameacas.where(grupo: "masmorras").order(:nd)
    #   Tormenta20.ameacas.find("basilisco")
    class Ameaca < Base
      self.table_name = "ameacas"

      validates :id, presence: true, uniqueness: true
      validates :name, presence: true
      validates :nd, presence: true
      validates :grupo, presence: true

      scope :by_grupo, ->(g) { where(grupo: g) }
      scope :by_nd, ->(n) { where(nd: n) }
      scope :up_to_nd, ->(n) { where(nd: ..n) }
      scope :masmorras,        -> { where(grupo: "masmorras") }
      scope :ermos,            -> { where(grupo: "ermos") }
      scope :puristas,         -> { where(grupo: "puristas") }
      scope :reino_dos_mortos, -> { where(grupo: "reino_dos_mortos") }
      scope :duyshidakk,       -> { where(grupo: "duyshidakk") }
      scope :sszzaazitas,      -> { where(grupo: "sszzaazitas") }
      scope :trolls_nobres,    -> { where(grupo: "trolls_nobres") }
      scope :dragoes,          -> { where(grupo: "dragoes") }
      scope :tormenta,         -> { where(grupo: "tormenta") }
      scope :avatares,         -> { where(grupo: "avatares") }

      def atributos
        { for: self[:for], des: des, con: con, int: self[:int], sab: sab, car: car }
      end

      def to_h
        {
          id: id,
          name: name,
          nd: nd,
          tipo: tipo,
          subtipo: subtipo,
          tamanho: tamanho,
          grupo: grupo,
          pv: pv,
          defesa: defesa,
          atributos: atributos,
          iniciativa: iniciativa,
          deslocamento: deslocamento,
          salvaguardas: salvaguardas,
          percepcao: percepcao,
          visao: visao,
          ataques: ataques,
          poderes_especiais: poderes_especiais,
          imunidades: imunidades,
          resistencias: resistencias,
          vulnerabilidades: vulnerabilidades,
          reducao_de_dano: reducao_de_dano,
          cura_acelerada: cura_acelerada,
          resistencia_a_magia: resistencia_a_magia,
          pericias: pericias,
          equipamento: equipamento,
          tesouro: tesouro,
          pm: pm,
          description: description,
          familiar: familiar,
          parceiro: parceiro
        }.compact
      end
    end
  end
end
