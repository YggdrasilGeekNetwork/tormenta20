# Melhorias

Acesso: `Tormenta20.melhorias`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome da melhoria |
| `description` | String | Descrição |
| `applicable_to` | Array | Tipos de item aplicáveis |
| `price` | String | Preço/custo |
| `effects` | Array | Efeitos da melhoria |

## Scopes (Filtros)

Este modelo não possui scopes específicos. Use queries ActiveRecord padrão.

## Métodos de Instância

```ruby
melhoria = Tormenta20.melhorias.first

melhoria.to_h  # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todas as melhorias
Tormenta20.melhorias.all.each do |m|
  puts "#{m.name}: #{m.price}"
end

# Buscar melhoria específica
melhoria = Tormenta20.melhorias.find("afiada")
puts melhoria.name           # Nome
puts melhoria.description    # Descrição
puts melhoria.price          # Preço
puts melhoria.applicable_to  # Tipos de item aplicáveis

# Melhorias para armas
Tormenta20.melhorias.select do |m|
  m.applicable_to&.include?("arma")
end

# Melhorias para armaduras
Tormenta20.melhorias.select do |m|
  m.applicable_to&.include?("armadura")
end

# Melhorias ordenadas por preço
Tormenta20.melhorias.order(:price)
```
