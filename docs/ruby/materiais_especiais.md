# Materiais Especiais

Acesso: `Tormenta20.materiais_especiais`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome do material |
| `description` | String | Descrição |
| `applicable_to` | Array | Tipos de item aplicáveis |
| `price_modifier` | String | Modificador de preço |
| `effects` | Array | Efeitos do material |

## Scopes (Filtros)

Este modelo não possui scopes específicos. Use queries ActiveRecord padrão.

## Métodos de Instância

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

# Buscar material específico
adamante = Tormenta20.materiais_especiais.find("adamante")
puts adamante.name            # => "Adamante"
puts adamante.price_modifier  # Modificador de preço
puts adamante.applicable_to   # Tipos de item aplicáveis
puts adamante.effects         # Efeitos

# Materiais aplicáveis a armas
Tormenta20.materiais_especiais.select do |m|
  m.applicable_to&.include?("arma")
end

# Materiais ordenados por nome
Tormenta20.materiais_especiais.order(:name)
```
