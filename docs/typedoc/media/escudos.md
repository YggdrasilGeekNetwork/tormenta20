# Escudos

Acesso: `Tormenta20.escudos`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome do escudo |
| `price` | String | Preço |
| `defense_bonus` | Integer | Bônus de defesa |
| `armor_penalty` | Integer | Penalidade de armadura |
| `weight` | String | Peso/espaços |
| `properties` | Array | Propriedades especiais |
| `description` | String | Descrição |

## Scopes (Filtros)

Este modelo não possui scopes específicos. Use queries ActiveRecord padrão.

## Métodos de Instância

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

# Buscar escudo específico
escudo = Tormenta20.escudos.find("escudo_leve")
puts escudo.name           # Nome
puts escudo.defense_bonus  # Bônus de defesa
puts escudo.armor_penalty  # Penalidade

# Escudo com maior bônus
Tormenta20.escudos.order(defense_bonus: :desc).first

# Escudos ordenados por preço
Tormenta20.escudos.order(:price)
```
