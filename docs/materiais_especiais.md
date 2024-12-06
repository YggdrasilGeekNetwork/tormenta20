# Materiais Especiais

Acesso: `Tormenta20.materiais_especiais`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome do material |
| `description` | String | Descricao |
| `applicable_to` | Array | Tipos de item aplicaveis |
| `price_modifier` | String | Modificador de preco |
| `effects` | Array | Efeitos do material |

## Scopes (Filtros)

Este modelo nao possui scopes especificos. Use queries ActiveRecord padrao.

## Metodos de Instancia

```ruby
material = Tormenta20.materiais_especiais.first

material.to_h  # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todos os materiais especiais
Tormenta20.materiais_especiais.all.each do |m|
  puts "#{m.name}: #{m.description}"
end

# Buscar material especifico
adamante = Tormenta20.materiais_especiais.find("adamante")
puts adamante.name            # => "Adamante"
puts adamante.price_modifier  # Modificador de preco
puts adamante.applicable_to   # Tipos de item aplicaveis
puts adamante.effects         # Efeitos

# Materiais aplicaveis a armas
Tormenta20.materiais_especiais.select do |m|
  m.applicable_to&.include?("arma")
end

# Materiais ordenados por nome
Tormenta20.materiais_especiais.order(:name)
```
