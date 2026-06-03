# Armaduras

Acesso: `Tormenta20.armaduras`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome da armadura |
| `category` | String | Categoria: `leve`, `pesada` |
| `price` | String | Preço |
| `defense_bonus` | Integer | Bônus de defesa |
| `armor_penalty` | Integer | Penalidade de armadura |
| `weight` | String | Peso/espaços |
| `properties` | Array | Propriedades especiais |
| `description` | String | Descrição |

## Scopes (Filtros)

### Por Categoria

```ruby
Tormenta20.armaduras.leves    # Armaduras leves
Tormenta20.armaduras.pesadas  # Armaduras pesadas
Tormenta20.armaduras.by_category("leve")
```

## Métodos de Instância

```ruby
armadura = Tormenta20.armaduras.find("couro")

armadura.leve?    # Verifica se é armadura leve
# => true

armadura.pesada?  # Verifica se é armadura pesada
# => false

armadura.to_h     # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todas as armaduras
Tormenta20.armaduras.all.each do |a|
  puts "#{a.name}: +#{a.defense_bonus} Defesa, -#{a.armor_penalty} penalidade"
end

# Armaduras leves
Tormenta20.armaduras.leves.each do |a|
  puts "#{a.name} - #{a.price}"
end

# Armaduras pesadas ordenadas por bônus de defesa
Tormenta20.armaduras.pesadas.order(defense_bonus: :desc).each do |a|
  puts "#{a.name}: +#{a.defense_bonus}"
end

# Buscar armadura específica
brunea = Tormenta20.armaduras.find("brunea")
puts brunea.name           # => "Brunea"
puts brunea.defense_bonus  # Bônus de defesa
puts brunea.armor_penalty  # Penalidade

# Armadura com maior bônus de defesa
Tormenta20.armaduras.order(defense_bonus: :desc).first

# Armaduras sem penalidade
Tormenta20.armaduras.where(armor_penalty: 0)
```
