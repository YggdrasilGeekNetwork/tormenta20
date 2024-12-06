#!/usr/bin/env ruby
# frozen_string_literal: true

# Example: Using Tormenta20 library with SQLite database

require_relative "../src/ruby/tormenta20"

# 1. Setup database (choose a mode)
# ----------------------------------

# Option A: Lazy mode (default) - database initialized on first use
Tormenta20.setup(mode: :lazy)

# Option B: Built-in mode - use pre-built database
# Tormenta20.setup(mode: :builtin)

# Option C: Build mode - build database immediately
# Tormenta20.setup(mode: :build)

# Option D: Custom database path
# Tormenta20.setup(mode: :lazy, db_path: "./custom_tormenta20.db")

# 2. Query spells
# ---------------

puts "=== All Spells ==="
puts "Total spells: #{Tormenta20::Models::Magia.count}"
puts ""

# Get all divine spells
puts "=== Divine Spells ==="
divine_spells = Tormenta20::Models::Magia.divinas
puts "Found #{divine_spells.count} divine spells"
divine_spells.limit(3).each do |spell|
  puts "- #{spell.name} (Circle #{spell.circle})"
end
puts ""

# Get all arcane spells
puts "=== Arcane Spells ==="
arcane_spells = Tormenta20::Models::Magia.arcanas
puts "Found #{arcane_spells.count} arcane spells"
arcane_spells.limit(3).each do |spell|
  puts "- #{spell.name} (Circle #{spell.circle})"
end
puts ""

# Filter by circle
puts "=== 3rd Circle Spells ==="
third_circle = Tormenta20::Models::Magia.by_circle(3)
puts "Found #{third_circle.count} 3rd circle spells"
third_circle.limit(3).each do |spell|
  puts "- #{spell.name} (#{spell.type})"
end
puts ""

# Filter by school
puts "=== Evocation Spells ==="
evocation = Tormenta20::Models::Magia.by_school("evoc")
puts "Found #{evocation.count} evocation spells"
evocation.limit(3).each do |spell|
  puts "- #{spell.name} (Circle #{spell.circle})"
end
puts ""

# 3. Find specific spell
# ----------------------

puts "=== Specific Spell: Bola de Fogo ==="
fireball = Tormenta20::Models::Magia.find("bola_de_fogo")
puts "Name: #{fireball.name}"
puts "Type: #{fireball.type}"
puts "Circle: #{fireball.circle}"
puts "School: #{fireball.school}"
puts "Range: #{fireball.range}"
puts "Duration: #{fireball.duration}"
puts "Description: #{fireball.description[0..100]}..."
puts "Enhancements: #{fireball.enhancements.size}"
puts "Effects: #{fireball.effects.size}"
puts ""

# 4. Complex queries with ActiveRecord
# -------------------------------------

puts "=== Complex Queries ==="

# Chain scopes
high_level_divine = Tormenta20::Models::Magia
                    .divinas
                    .where("CAST(circle AS INTEGER) >= ?", 4)
                    .order(:circle, :name)

puts "Divine spells of 4th circle or higher: #{high_level_divine.count}"
high_level_divine.limit(5).each do |spell|
  puts "- [Circle #{spell.circle}] #{spell.name}"
end
puts ""

# Search by name
fire_spells = Tormenta20::Models::Magia
              .where("name LIKE ?", "%fogo%")
              .or(Tormenta20::Models::Magia.where("name LIKE ?", "%Fogo%"))

puts "Spells with 'fogo' in the name: #{fire_spells.count}"
fire_spells.each do |spell|
  puts "- #{spell.name} (Circle #{spell.circle})"
end
puts ""

# 5. Working with spell data
# --------------------------

puts "=== Spell Details ==="
spell = Tormenta20::Models::Magia.arcanas.first

# Access as hash
spell_hash = spell.to_h
puts "As hash: #{spell_hash.keys.join(", ")}"
puts ""

# Access target info
target = spell.target_info
puts "Target: #{target}"
puts ""

# Access resistance info
if spell.resistence_info
  puts "Resistance: #{spell.resistence_info}"
else
  puts "No resistance save"
end
puts ""

# 6. Statistics
# -------------

puts "=== Statistics ==="
puts "Total spells: #{Tormenta20::Models::Magia.count}"
puts "Arcane spells: #{Tormenta20::Models::Magia.arcanas.count}"
puts "Divine spells: #{Tormenta20::Models::Magia.divinas.count}"
puts "Universal spells: #{Tormenta20::Models::Magia.universais.count}"
puts ""

puts "Spells by circle:"
(1..9).each do |circle|
  count = Tormenta20::Models::Magia.by_circle(circle).count
  puts "  Circle #{circle}: #{count} spells" if count.positive?
end
puts ""

puts "Spells by school:"
%w[abjur evoc conj div enc ilusão necro trans].each do |school|
  count = Tormenta20::Models::Magia.by_school(school).count
  puts "  #{school.capitalize}: #{count} spells" if count.positive?
end
