# frozen_string_literal: true

require_relative "../src/ruby/tormenta20"
require "json"

# Seed script to import JSON data into SQLite database

module Tormenta20
  # Seeds module for importing JSON data into the SQLite database.
  #
  # This module provides methods to import all Tormenta20 game data
  # from JSON files into the database.
  #
  # @example Import all data
  #   Tormenta20::Seeds.import_all
  #
  # @example Clear and reimport
  #   Tormenta20::Seeds.clear_all
  #   Tormenta20::Seeds.import_all
  module Seeds
    JSON_BASE_PATH = File.expand_path("../src/json", __dir__)

    class << self
      def import_all
        puts "Starting data import..."
        puts "=" * 60

        import_origens
        import_poderes_habilidades_unicas
        import_divindades
        import_poderes_concedidos
        import_poderes_tormenta
        import_classes
        import_magias
        import_equipamentos
        import_itens_superiores
        import_regras

        puts "=" * 60
        puts "Data import completed!"
        print_summary
      end

      # =======================================================================
      # ORIGENS
      # =======================================================================
      def import_origens
        import_json_files(
          "origens",
          Models::Origem,
          %i[id name description items benefits unique_power]
        )
      end

      # =======================================================================
      # PODERES - HABILIDADES ÚNICAS DE ORIGEM
      # =======================================================================
      def import_poderes_habilidades_unicas
        import_json_files(
          "poderes/habilidades_unicas_de_origem",
          Models::Poder,
          %i[id name description effects prerequisites],
          extra_attrs: { type: "habilidade_unica_origem" },
          transform: lambda { |data|
            data[:origin_id] = data.delete(:origin) if data[:origin]
            data
          }
        )
      end

      # =======================================================================
      # DIVINDADES
      # =======================================================================
      def import_divindades
        import_json_files(
          "deuses",
          Models::Divindade,
          %i[id name title description beliefs_objectives holy_symbol energy
             preferred_weapon devotees granted_powers obligations_restrictions]
        )
      end

      # =======================================================================
      # PODERES CONCEDIDOS
      # =======================================================================
      def import_poderes_concedidos
        import_json_files(
          "poderes/poderes_concedidos",
          Models::Poder,
          %i[id name description effects prerequisites deities],
          extra_attrs: { type: "poder_concedido" }
        )
      end

      # =======================================================================
      # PODERES DA TORMENTA
      # =======================================================================
      def import_poderes_tormenta
        import_json_files(
          "poderes/poderes_da_tormenta",
          Models::Poder,
          %i[id name description effects prerequisites],
          extra_attrs: { type: "poder_tormenta" }
        )
      end

      # =======================================================================
      # CLASSES
      # =======================================================================
      def import_classes
        import_json_files(
          "classes",
          Models::Classe,
          %i[id name hit_points mana_points skills proficiencies abilities powers progression spellcasting]
        )
      end

      # =======================================================================
      # MAGIAS
      # =======================================================================
      def import_magias
        puts "\nImporting magias..."

        json_dir = File.join(JSON_BASE_PATH, "magias")
        return puts "  Directory not found: #{json_dir}" unless Dir.exist?(json_dir)

        files = Dir.glob(File.join(json_dir, "*.json"))
        puts "  Found #{files.size} magia files"

        success_count = 0
        error_count = 0

        files.each_with_index do |file, index|
          data = JSON.parse(File.read(file), symbolize_names: true)
          import_magia(data)
          success_count += 1
          print "\r  Imported: #{index + 1}/#{files.size}" if ((index + 1) % 10).zero?
        rescue StandardError => e
          error_count += 1
          puts "\n  Error importing #{File.basename(file)}: #{e.message}"
        end

        puts "\n  Successfully imported #{success_count} magias"
        puts "  Failed to import #{error_count} magias" if error_count.positive?
      end

      def import_magia(data)
        raw_target = data[:target]
        target = if raw_target.is_a?(Hash)
                   raw_target
                 else
                   (raw_target.is_a?(Array) ? raw_target.first || {} : {})
                 end
        effect_details = data[:effect_details].is_a?(Hash) ? data[:effect_details] : {}
        resistence = data[:resistence].is_a?(Hash) ? data[:resistence] : {}
        extra_costs = data[:extra_costs].is_a?(Hash) ? data[:extra_costs] : {}

        Models::Magia.find_or_initialize_by(id: data[:id]).tap do |magia|
          magia.name = data[:name]
          magia.type = data[:type]
          magia.circle = data[:circle]
          magia.school = data[:school]
          magia.execution = data[:execution]
          magia.execution_details = data[:execution_details]
          magia.range = data[:range]
          magia.duration = data[:duration]
          magia.duration_details = data[:duration_details]
          magia.counterspell = data[:counterspell]
          magia.description = data[:description] || ""

          magia.target_amount = target[:amount]
          magia.target_up_to = if target[:up_to].nil?
                                 nil
                               else
                                 (target[:up_to] ? 1 : 0)
                               end
          magia.target_type = target[:type]

          magia.effect = data[:effect]
          magia.effect_shape = effect_details[:shape]
          magia.effect_dimention = effect_details[:dimention]
          magia.effect_size = effect_details[:size]
          magia.effect_other_details = effect_details[:other_details]

          magia.area_effect = data[:area_effect]
          magia.area_effect_details = data[:area_effect_details]

          magia.resistence_effect = resistence[:effect]
          magia.resistence_skill = resistence[:skill]

          magia.extra_costs_material_component = extra_costs[:material_component]
          magia.extra_costs_material_cost = extra_costs[:material_component_cost]
          magia.extra_costs_pm_debuff = extra_costs[:pm_debuff]
          magia.extra_costs_pm_sacrifice = extra_costs[:pm_sacrifice]

          magia.enhancements = data[:enhancements] || []
          magia.effects = data[:effects] || []

          magia.save!
        end
      end

      # =======================================================================
      # EQUIPAMENTOS
      # =======================================================================
      def import_equipamentos
        import_armas
        import_armaduras
        import_escudos
        import_itens
      end

      def import_armas
        import_json_files(
          "equipamentos/armas",
          Models::Arma,
          %i[id name category price damage damage_type critical range weight properties description]
        )
      end

      def import_armaduras
        import_json_files(
          "equipamentos/armaduras",
          Models::Armadura,
          %i[id name category price defense_bonus armor_penalty weight properties description]
        )
      end

      def import_escudos
        import_json_files(
          "equipamentos/escudos",
          Models::Escudo,
          %i[id name price defense_bonus armor_penalty weight properties description],
          transform: lambda { |data|
            data[:price] ||= data.delete(:preco)
            data[:defense_bonus] ||= data.delete(:bonus_defesa)
            data[:armor_penalty] ||= data.delete(:penalidade_armadura)
            data[:weight] ||= data.delete(:espacos)
            data
          }
        )
      end

      def import_itens
        import_json_files(
          "equipamentos/itens",
          Models::Item,
          %i[id name category price weight description effects]
        )
      end

      # =======================================================================
      # ITENS SUPERIORES
      # =======================================================================
      def import_itens_superiores
        import_materiais_especiais
        import_melhorias
      end

      def import_materiais_especiais
        import_json_files(
          "itens_superiores/materiais_especiais",
          Models::MaterialEspecial,
          %i[id name description applicable_to price_modifier effects]
        )
      end

      def import_melhorias
        import_json_files(
          "itens_superiores/melhorias",
          Models::Melhoria,
          %i[id name description applicable_to price effects]
        )
      end

      # =======================================================================
      # REGRAS
      # =======================================================================
      def import_regras
        import_json_files(
          "regras",
          Models::Regra,
          %i[id name description data],
          transform: lambda { |raw|
            base_keys = %i[id name description]
            data_content = raw.reject { |k, _| base_keys.include?(k) }
            { id: raw[:id], name: raw[:name], description: raw[:description], data: data_content }
          }
        )
      end

      # =======================================================================
      # UTILITY METHODS
      # =======================================================================
      def clear_all
        puts "Clearing all data..."
        [
          Models::Origem, Models::Poder, Models::Divindade, Models::Classe,
          Models::Magia, Models::Arma, Models::Armadura, Models::Escudo,
          Models::Item, Models::MaterialEspecial, Models::Melhoria, Models::Regra
        ].each(&:delete_all)
        puts "Data cleared!"
      end

      def print_summary
        puts "\nDatabase Summary:"
        puts "-" * 40
        puts "  Origens:            #{Models::Origem.count}"
        puts "  Poderes:            #{Models::Poder.count}"
        puts "    - Hab. Unicas:    #{Models::Poder.habilidades_unicas.count}"
        puts "    - Concedidos:     #{Models::Poder.poderes_concedidos.count}"
        puts "    - Tormenta:       #{Models::Poder.poderes_tormenta.count}"
        puts "  Divindades:         #{Models::Divindade.count}"
        puts "  Classes:            #{Models::Classe.count}"
        puts "  Magias:             #{Models::Magia.count}"
        puts "  Armas:              #{Models::Arma.count}"
        puts "  Armaduras:          #{Models::Armadura.count}"
        puts "  Escudos:            #{Models::Escudo.count}"
        puts "  Itens:              #{Models::Item.count}"
        puts "  Materiais Esp.:     #{Models::MaterialEspecial.count}"
        puts "  Melhorias:          #{Models::Melhoria.count}"
        puts "  Regras:             #{Models::Regra.count}"
        puts "-" * 40
      end

      private

      def import_json_files(subdir, model, attrs, extra_attrs: {}, transform: nil)
        entity_name = subdir.split("/").last
        puts "\nImporting #{entity_name}..."

        json_dir = File.join(JSON_BASE_PATH, subdir)
        unless Dir.exist?(json_dir)
          puts "  Directory not found: #{json_dir}"
          return
        end

        files = Dir.glob(File.join(json_dir, "*.json"))
        puts "  Found #{files.size} files"

        return if files.empty?

        success_count = 0
        error_count = 0

        files.each_with_index do |file, index|
          data = JSON.parse(File.read(file), symbolize_names: true)
          data = transform.call(data) if transform

          record = model.find_or_initialize_by(id: data[:id])
          attrs.each do |attr|
            record.send("#{attr}=", data[attr]) if data.key?(attr)
          end
          extra_attrs.each do |attr, value|
            record.send("#{attr}=", value)
          end
          record.save!

          success_count += 1
          print "\r  Imported: #{index + 1}/#{files.size}" if ((index + 1) % 10).zero?
        rescue StandardError => e
          error_count += 1
          puts "\n  Error importing #{File.basename(file)}: #{e.message}"
        end

        puts "\n  Successfully imported #{success_count} #{entity_name}"
        puts "  Failed to import #{error_count} #{entity_name}" if error_count.positive?
      end
    end
  end
end

# Run seeds if this file is executed directly
if __FILE__ == $PROGRAM_NAME
  Tormenta20::Database.setup(mode: :build)
  Tormenta20::Seeds.import_all
end
