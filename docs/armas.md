# Armas

Acesso: `Tormenta20.armas`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome da arma |
| `category` | String | Categoria: `simples`, `marciais`, `exoticas`, `fogo` |
| `price` | String | Preco |
| `damage` | String | Dano (ex: "1d8") |
| `damage_type` | String | Tipo de dano (corte, perfuracao, etc) |
| `critical` | String | Critico (ex: "19/x2") |
| `range` | String | Alcance (para armas de distancia) |
| `weight` | String | Peso/espacos |
| `properties` | Array | Propriedades especiais |
| `description` | String | Descricao |

## Scopes (Filtros)

### Por Categoria

```ruby
Tormenta20.armas.simples    # Armas simples
Tormenta20.armas.marciais   # Armas marciais
Tormenta20.armas.exoticas   # Armas exoticas
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
Tormenta20.armas.ranged  # Armas de distancia (com alcance)
Tormenta20.armas.melee   # Armas corpo a corpo (sem alcance)
```

## Metodos de Instancia

```ruby
arma = Tormenta20.armas.find("espada_longa")

arma.ranged?  # Verifica se e arma de distancia
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

# Armas de distancia
Tormenta20.armas.ranged.each do |a|
  puts "#{a.name}: alcance #{a.range}"
end

# Armas de corte
Tormenta20.armas.by_damage_type("corte").each do |a|
  puts "#{a.name}: #{a.damage}"
end

# Buscar arma especifica
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
