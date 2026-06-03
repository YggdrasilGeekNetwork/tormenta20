# Regras

Acesso: `Tormenta20.regras`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome da regra/tabela |
| `description` | String | Descrição |
| `data` | Hash | Dados estruturados da regra |

## Scopes (Filtros)

Este modelo não possui scopes específicos. Use queries ActiveRecord padrão.

## Métodos de Instância

```ruby
regra = Tormenta20.regras.first

regra.to_h  # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todas as regras
Tormenta20.regras.all.each do |r|
  puts "#{r.name}: #{r.description}"
end

# Buscar regra específica
pericias = Tormenta20.regras.find("pericias")
puts pericias.name         # => "Pericias"
puts pericias.description  # Descrição
puts pericias.data         # Dados estruturados (Hash)

# Acessar dados de uma regra
condicoes = Tormenta20.regras.find("condicoes")
condicoes.data.each do |key, value|
  puts "#{key}: #{value}"
end

# Buscar regras por nome
Tormenta20.regras.where("name LIKE ?", "%combate%")

# Regras ordenadas por nome
Tormenta20.regras.order(:name)
```
