# Divindades

Acesso: `Tormenta20.divindades`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome da divindade |
| `title` | String | Título/epíteto |
| `description` | String | Descrição |
| `beliefs_objectives` | String | Crenças e objetivos |
| `holy_symbol` | String | Símbolo sagrado |
| `energy` | String | Tipo de energia: `positiva`, `negativa`, `qualquer` |
| `preferred_weapon` | String | Arma preferida |
| `devotees` | Hash | Devotos típicos (races, classes) |
| `granted_powers` | Array | Lista de poderes concedidos |
| `obligations_restrictions` | String | Obrigações e restrições |

## Scopes (Filtros)

### Por Tipo de Energia

```ruby
Tormenta20.divindades.energia_positiva  # Deuses de energia positiva
Tormenta20.divindades.energia_negativa  # Deuses de energia negativa
Tormenta20.divindades.energia_qualquer  # Deuses de energia neutra
Tormenta20.divindades.by_energy("positiva")
```

## Métodos de Instância

```ruby
divindade = Tormenta20.divindades.find("khalmyr")

divindade.races    # Raças devotas
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

# Buscar divindade específica
khalmyr = Tormenta20.divindades.find("khalmyr")
puts khalmyr.name              # => "Khalmyr"
puts khalmyr.title             # => "O Deus da Justiça"
puts khalmyr.preferred_weapon  # => "Espada longa"
puts khalmyr.granted_powers    # Lista de poderes concedidos

# Divindades que concedem um poder específico
Tormenta20.divindades.select do |d|
  d.granted_powers&.include?("cura_pelas_maos")
end

# Agrupar por tipo de energia
Tormenta20.divindades.group(:energy).count
# => {"positiva"=>12, "negativa"=>6, "qualquer"=>2}

# Divindades adoradas por uma raça
Tormenta20.divindades.select { |d| d.races.include?("elfo") }
```
