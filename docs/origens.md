# Origens

Acesso: `Tormenta20.origens`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome da origem |
| `description` | String | Descricao da origem |
| `items` | Array | Itens iniciais |
| `benefits` | Hash | Beneficios (skills, powers) |
| `unique_power` | Hash | Poder unico da origem |

## Scopes (Filtros)

```ruby
# Origens que possuem poder unico
Tormenta20.origens.with_unique_power
```

## Metodos de Instancia

```ruby
origem = Tormenta20.origens.find("soldado")

origem.skills   # Pericias treinadas pela origem
# => ["Fortitude", "Luta"]

origem.powers   # Poderes concedidos pela origem
# => ["Proficiencia"]

origem.to_h     # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todas as origens
Tormenta20.origens.all.each do |o|
  puts "#{o.name}: #{o.skills.join(', ')}"
end

# Origens com poder unico
Tormenta20.origens.with_unique_power.each do |o|
  puts "#{o.name}: #{o.unique_power['name']}"
end

# Buscar origem especifica
soldado = Tormenta20.origens.find("soldado")
puts soldado.name         # => "Soldado"
puts soldado.description  # Descricao completa
puts soldado.items        # Itens iniciais

# Origens que concedem uma pericia especifica
Tormenta20.origens.select { |o| o.skills.include?("Furtividade") }

# Contar origens com poder unico
Tormenta20.origens.with_unique_power.count
```
