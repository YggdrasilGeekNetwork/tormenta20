# Armas

Acesso: `Tormenta20.armas`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome da arma |
| `category` | String | Categoria: `simples`, `marciais`, `exoticas`, `fogo` |
| `price` | String | Preço |
| `damage` | String | Dano (ex: "1d8") |
| `damage_type` | String | Tipo de dano (corte, perfuração, etc) |
| `critical` | String | Crítico (ex: "19/x2") |
| `range` | String | Alcance (para armas de distância) |
| `weight` | String | Peso/espaços |
| `properties` | Array | Propriedades especiais |
| `description` | String | Descrição |

## Scopes (Filtros)

### Por Categoria

```ruby
Tormenta20.armas.simples    # Armas simples
Tormenta20.armas.marciais   # Armas marciais
Tormenta20.armas.exoticas   # Armas exóticas
Tormenta20.armas.fogo       # Armas de fogo
Tormenta20.armas.by_category("simples")
```

### Por Tipo de Dano

```ruby
Tormenta20.armas.by_damage_type("corte")
Tormenta20.armas.by_damage_type("perfuracao")
Tormenta20.armas.by_damage_type("impacto")
```

### Por Alcance

```ruby
Tormenta20.armas.ranged  # Armas de distância (com alcance)
Tormenta20.armas.melee   # Armas corpo a corpo (sem alcance)
```

## Métodos de Instância

```ruby
arma = Tormenta20.armas.find("espada_longa")

arma.ranged?  # Verifica se é arma de distância
# => false

arma.to_h     # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todas as armas
Tormenta20.armas.all.each do |a|
  puts "#{a.name}: #{a.damage} (#{a.damage_type})"
end

# Armas simples
Tormenta20.armas.simples.each do |a|
  puts "#{a.name} - #{a.price}"
end

# Armas de distância
Tormenta20.armas.ranged.each do |a|
  puts "#{a.name}: alcance #{a.range}"
end

# Armas de corte
Tormenta20.armas.by_damage_type("corte").each do |a|
  puts "#{a.name}: #{a.damage}"
end

# Buscar arma específica
espada = Tormenta20.armas.find("espada_longa")
puts espada.name        # => "Espada Longa"
puts espada.damage      # => "1d8"
puts espada.critical    # => "19/x2"
puts espada.properties  # Propriedades especiais

# Armas ordenadas por dano
Tormenta20.armas.order(:damage).reverse

# Contar armas por categoria
Tormenta20.armas.group(:category).count
# => {"simples"=>15, "marciais"=>20, "exoticas"=>10, "fogo"=>5}
```
