# Classes

Acesso: `Tormenta20.classes`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome da classe |
| `hit_points` | Hash | Pontos de vida (initial, per_level) |
| `mana_points` | Hash | Pontos de mana (per_level) |
| `skills` | Hash | Pericias (mandatory, choose_amount, choose_from) |
| `proficiencies` | Hash | Proficiencias (weapons, armors, shields) |
| `abilities` | Array | Habilidades da classe |
| `powers` | Array | Poderes disponiveis |
| `progression` | Hash | Progressao por nivel |
| `spellcasting` | Hash | Informacoes de conjuracao (se aplicavel) |

## Scopes (Filtros)

```ruby
# Classes que podem conjurar magias
Tormenta20.classes.conjuradores
```

## Metodos de Instancia

### Pontos de Vida e Mana

```ruby
classe = Tormenta20.classes.find("guerreiro")

classe.initial_hp      # PV inicial (ex: 20)
classe.hp_per_level    # PV por nivel (ex: 5)
classe.mp_per_level    # PM por nivel (ex: 3)
```

### Pericias

```ruby
classe.mandatory_skills     # Pericias obrigatorias
# => ["Luta", "Fortitude"]

classe.choose_skills_amount # Quantidade de pericias a escolher
# => 4

classe.available_skills     # Pericias disponiveis para escolha
# => ["Atletismo", "Cavalgar", "Intimidacao", ...]
```

### Proficiencias

```ruby
classe.weapon_proficiencies  # Proficiencias em armas
# => ["simples", "marciais"]

classe.armor_proficiencies   # Proficiencias em armaduras
# => ["leves", "pesadas"]

classe.shield_proficiency?   # Proficiencia em escudos
# => true
```

### Conjuracao

```ruby
classe.conjurador?  # Verifica se a classe conjura magias
# => false (para Guerreiro)
# => true (para Arcanista)
```

### Conversao

```ruby
classe.to_h  # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todas as classes
Tormenta20.classes.all.each do |c|
  puts "#{c.name}: #{c.initial_hp} PV inicial, +#{c.hp_per_level}/nivel"
end

# Classes conjuradoras
Tormenta20.classes.conjuradores.each do |c|
  puts "#{c.name} - PM/nivel: #{c.mp_per_level}"
end

# Buscar classe especifica
arcanista = Tormenta20.classes.find("arcanista")
puts arcanista.name                  # => "Arcanista"
puts arcanista.conjurador?           # => true
puts arcanista.available_skills      # Lista de pericias

# Classes com mais PV inicial
Tormenta20.classes.all.sort_by { |c| -c.initial_hp }.each do |c|
  puts "#{c.name}: #{c.initial_hp} PV"
end

# Classes com proficiencia em armaduras pesadas
Tormenta20.classes.select { |c| c.armor_proficiencies.include?("pesadas") }
```
