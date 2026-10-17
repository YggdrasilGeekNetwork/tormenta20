# frozen_string_literal: true

require_relative "../spec_helper"

# Cross-table referential integrity checks.
#
# Several tables reference records in other tables by id, stored as plain JSON
# (string or array of strings) rather than a SQL foreign key — a deliberate
# project convention (see CLAUDE.md) that avoids rigid FKs for things like
# `poderes.deities` or `divindades.granted_powers`. Nothing else in the suite
# verifies these ids actually resolve, so a typo'd or renamed id would pass
# every other spec silently. This file is the one place that walks each
# cross-reference and asserts it points at something real.
#
# Deliberately NOT covered: `ameacas.equipamento`. Unlike the references
# below, it has never been an id reference — core-book entries store it as
# free-text display strings (e.g. "Machado de guerra cruel"), not ids, so
# there's no real id-shaped invariant to assert there.
RSpec.describe "Cross-table references" do
  let(:divindade_ids) { Tormenta20::Models::Divindade.pluck(:id).to_set }
  let(:poder_ids) { Tormenta20::Models::Poder.pluck(:id).to_set }

  describe "Poder#deities" do
    it "only references existing divindades" do
      orphans = []
      Tormenta20::Models::Poder.where.not(deities: "[]").find_each do |poder|
        poder.deities.each do |deity_id|
          orphans << "#{poder.id} -> #{deity_id}" unless divindade_ids.include?(deity_id)
        end
      end
      expect(orphans).to be_empty
    end
  end

  describe "Divindade#granted_powers" do
    it "only references existing poderes" do
      orphans = []
      Tormenta20::Models::Divindade.find_each do |divindade|
        divindade.granted_powers.each do |power_id|
          orphans << "#{divindade.id} -> #{power_id}" unless poder_ids.include?(power_id)
        end
      end
      expect(orphans).to be_empty
    end
  end

  describe "ItemLiturgico#deities" do
    it "only references existing divindades" do
      orphans = []
      Tormenta20::Models::ItemLiturgico.find_each do |item|
        item.deities.each do |deity_id|
          orphans << "#{item.id} -> #{deity_id}" unless divindade_ids.include?(deity_id)
        end
      end
      expect(orphans).to be_empty
    end
  end

  describe "Classe#abilities and #powers" do
    it "only reference existing poderes" do
      orphans = []
      Tormenta20::Models::Classe.find_each do |classe|
        (classe.abilities + classe.powers).each do |power_id|
          orphans << "#{classe.id} -> #{power_id}" unless poder_ids.include?(power_id)
        end
      end
      expect(orphans).to be_empty
    end
  end
end
