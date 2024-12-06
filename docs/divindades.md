# Divindades

Acesso: `Tormenta20.divindades`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome da divindade |
| `title` | String | Titulo/epiteto |
| `description` | String | Descricao |
| `beliefs_objectives` | String | Crencas e objetivos |
| `holy_symbol` | String | Simbolo sagrado |
| `energy` | String | Tipo de energia: `positiva`, `negativa`, `qualquer` |
| `preferred_weapon` | String | Arma preferida |
| `devotees` | Hash | Devotos tipicos (races, classes) |
| `granted_powers` | Array | Lista de poderes concedidos |
| `obligations_restrictions` | String | Obrigacoes e restricoes |

## Scopes (Filtros)

### Por Tipo de Energia

```ruby
Tormenta20.divindades.energia_positiva  # Deuses de energia positiva
Tormenta20.divindades.energia_negativa  # Deuses de energia negativa
Tormenta20.divindades.energia_qualquer  # Deuses de energia neutra
Tormenta20.divindades.by_energy("positiva")
```

## Metodos de Instancia

```ruby
divindade = Tormenta20.divindades.find("khalmyr")

divindade.races    # Racas devotas
# => ["humano", "anao"]

divindade.classes  # Classes devotas
# => ["paladino", "guerreiro"]

divindade.to_h     # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todas as divindades
Tormenta20.divindades.all.each do |d|
  puts "#{d.name} - #{d.title} (#{d.energy})"
end

# Divindades de energia positiva
Tormenta20.divindades.energia_positiva.each do |d|
  puts "#{d.name}: #{d.granted_powers.join(', ')}"
end

# Buscar divindade especifica
khalmyr = Tormenta20.divindades.find("khalmyr")
puts khalmyr.name              # => "Khalmyr"
puts khalmyr.title             # => "O Deus da Justica"
puts khalmyr.preferred_weapon  # => "Espada longa"
puts khalmyr.granted_powers    # Lista de poderes concedidos

# Divindades que concedem um poder especifico
Tormenta20.divindades.select do |d|
  d.granted_powers&.include?("cura_pelas_maos")
end

# Agrupar por tipo de energia
Tormenta20.divindades.group(:energy).count
# => {"positiva"=>12, "negativa"=>6, "qualquer"=>2}

# Divindades adoradas por uma raca
Tormenta20.divindades.select { |d| d.races.include?("elfo") }
```
