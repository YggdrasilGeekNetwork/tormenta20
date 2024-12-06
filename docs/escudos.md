# Escudos

Acesso: `Tormenta20.escudos`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome do escudo |
| `price` | String | Preco |
| `defense_bonus` | Integer | Bonus de defesa |
| `armor_penalty` | Integer | Penalidade de armadura |
| `weight` | String | Peso/espacos |
| `properties` | Array | Propriedades especiais |
| `description` | String | Descricao |

## Scopes (Filtros)

Este modelo nao possui scopes especificos. Use queries ActiveRecord padrao.

## Metodos de Instancia

```ruby
escudo = Tormenta20.escudos.first

escudo.to_h  # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todos os escudos
Tormenta20.escudos.all.each do |e|
  puts "#{e.name}: +#{e.defense_bonus} Defesa, -#{e.armor_penalty} penalidade"
end

# Buscar escudo especifico
escudo = Tormenta20.escudos.find("escudo_leve")
puts escudo.name           # Nome
puts escudo.defense_bonus  # Bonus de defesa
puts escudo.armor_penalty  # Penalidade

# Escudo com maior bonus
Tormenta20.escudos.order(defense_bonus: :desc).first

# Escudos ordenados por preco
Tormenta20.escudos.order(:price)
```
