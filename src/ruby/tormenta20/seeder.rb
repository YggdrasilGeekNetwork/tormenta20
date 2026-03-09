# frozen_string_literal: true

require "json"

module Tormenta20
  # Handles importing JSON data into the database
  module Seeder
    JSON_BASE_PATH = File.expand_path("../../json", __dir__)

    class << self
      def seed_all(verbose: false)
        @verbose = verbose
        log "Seeding database..."

        seed_racas
        seed_habilidades_de_raca
        seed_origens
        seed_poderes_habilidades_unicas
        seed_divindades
        seed_poderes_concedidos
        seed_poderes_tormenta
        seed_poderes_gerais
        seed_classes
        seed_habilidades_de_classe
        seed_magias
        seed_equipamentos
        seed_itens_superiores
        seed_regras
        seed_condicoes

        log "Database seeded successfully!"
      end

      def seeded?
        Models::Origem.count.positive?
      rescue StandardError
        false
      end

      private

      def log(message)
        puts message if @verbose
      end

      def seed_racas
        import_json_files(
          "racas",
          Models::Raca,
          %i[id name description size movement vision vision_range
             attribute_bonuses skill_bonuses racial_abilities
             chosen_abilities_amount available_chosen_abilities]
        )
      end

      def seed_habilidades_de_raca
        base_dir = File.join(JSON_BASE_PATH, "poderes", "habilidades_de_raca")
        return unless Dir.exist?(base_dir)

        Dir.each_child(base_dir) do |race_dir|
          race_path = File.join(base_dir, race_dir)
          next unless File.directory?(race_path)

          Dir.glob(File.join(race_path, "*.json")).each do |file|
            data = JSON.parse(File.read(file), symbolize_names: true)
            next if data[:id].nil?

            record = Models::Poder.find_or_initialize_by(id: data[:id])
            record.name        = data[:name] || data[:id].to_s.humanize
            record.type        = "habilidade_de_raca"
            record.description = data[:description]
            record.effects     = data[:effects] || {}
            record.prerequisites = data[:prerequisites] || []
            record.save!
          rescue StandardError
            next
          end
        end
      end

      def seed_origens
        import_json_files(
          "origens",
          Models::Origem,
          %i[id name description items benefits unique_power]
        )
      end

      def seed_poderes_habilidades_unicas
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

      def seed_divindades
        import_json_files(
          "deuses",
          Models::Divindade,
          %i[id name title description beliefs_objectives holy_symbol energy
             preferred_weapon devotees granted_powers obligations_restrictions]
        )
      end

      def seed_poderes_concedidos
        import_json_files(
          "poderes/poderes_concedidos",
          Models::Poder,
          %i[id name description effects prerequisites deities],
          extra_attrs: { type: "poder_concedido" }
        )
      end

      def seed_poderes_tormenta
        import_json_files(
          "poderes/poderes_da_tormenta",
          Models::Poder,
          %i[id name description effects prerequisites],
          extra_attrs: { type: "poder_tormenta" }
        )
      end

      def seed_poderes_gerais
        base_dir = File.join(JSON_BASE_PATH, "poderes", "poderes_gerais")
        return unless Dir.exist?(base_dir)

        Dir.glob(File.join(base_dir, "**", "*.json")).each do |file|
          data = JSON.parse(File.read(file), symbolize_names: true)
          next if data[:id].nil?

          record = Models::Poder.find_or_initialize_by(id: data[:id])
          record.name        = data[:name] || data[:id].to_s.humanize
          record.type        = data[:type] || "poder_geral"
          record.description = data[:description]
          record.effects     = data[:effects] || []
          record.costs       = data[:costs] || []
          record.prerequisites = data[:requirements] || []
          record.save!
        rescue StandardError
          next
        end
      end

      def seed_classes
        import_json_files(
          "classes",
          Models::Classe,
          %i[id name hit_points mana_points skills proficiencies abilities powers progression spellcasting]
        )
      end

      def seed_habilidades_de_classe
        base_dir = File.join(JSON_BASE_PATH, "poderes", "habilidades_de_classe")
        return unless Dir.exist?(base_dir)

        Dir.each_child(base_dir) do |class_dir|
          class_path = File.join(base_dir, class_dir)
          next unless File.directory?(class_path)
          next if class_dir == "base.json"

          class_id = class_dir

          Dir.glob(File.join(class_path, "*.json")).each do |file|
            data = JSON.parse(File.read(file), symbolize_names: true)
            next if data[:id].nil?

            record = Models::Poder.find_or_initialize_by(id: data[:id])
            record.name        = data[:name] || data[:id].to_s.humanize
            record.type        = "poder_classe"
            record.class_id    = class_id
            record.description = data[:description]
            record.effects     = data[:effects] || []
            record.costs       = data[:costs] || []
            record.prerequisites = data[:requirements] || []
            record.save!
          rescue StandardError
            next
          end
        end
      end

      def seed_magias
        json_dir = File.join(JSON_BASE_PATH, "magias")
        return unless Dir.exist?(json_dir)

        Dir.glob(File.join(json_dir, "*.json")).each do |file|
          data = JSON.parse(File.read(file), symbolize_names: true)
          import_magia(data)
        rescue StandardError
          next
        end
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

      def seed_equipamentos
        seed_armas
        seed_armaduras
        seed_escudos
        seed_itens
      end

      def seed_armas
        import_json_files(
          "equipamentos/armas",
          Models::Arma,
          %i[id name category price damage damage_type critical range weight properties description]
        )
      end

      def seed_armaduras
        import_json_files(
          "equipamentos/armaduras",
          Models::Armadura,
          %i[id name category price defense_bonus armor_penalty weight properties description]
        )
      end

      def seed_escudos
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

      def seed_itens
        import_json_files(
          "equipamentos/itens",
          Models::Item,
          %i[id name category price weight description effects]
        )
      end

      def seed_itens_superiores
        seed_materiais_especiais
        seed_melhorias
      end

      def seed_materiais_especiais
        import_json_files(
          "itens_superiores/materiais_especiais",
          Models::MaterialEspecial,
          %i[id name description applicable_to price_modifier effects]
        )
      end

      def seed_melhorias
        import_json_files(
          "itens_superiores/melhorias",
          Models::Melhoria,
          %i[id name description applicable_to price effects]
        )
      end

      def seed_regras
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

      def seed_condicoes
        import_json_files(
          "condicoes",
          Models::Condicao,
          %i[id name description effects condition_type escalates_to]
        )
      end

      def import_json_files(subdir, model, attrs, extra_attrs: {}, transform: nil)
        json_dir = File.join(JSON_BASE_PATH, subdir)
        return unless Dir.exist?(json_dir)

        Dir.glob(File.join(json_dir, "**", "*.json")).each do |file|
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
        rescue StandardError
          next
        end
      end
    end
  end
end

