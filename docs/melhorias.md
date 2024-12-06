# Melhorias

Acesso: `Tormenta20.melhorias`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome da melhoria |
| `description` | String | Descricao |
| `applicable_to` | Array | Tipos de item aplicaveis |
| `price` | String | Preco/custo |
| `effects` | Array | Efeitos da melhoria |

## Scopes (Filtros)

Este modelo nao possui scopes especificos. Use queries ActiveRecord padrao.

## Metodos de Instancia

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

# Buscar melhoria especifica
melhoria = Tormenta20.melhorias.find("afiada")
puts melhoria.name           # Nome
puts melhoria.description    # Descricao
puts melhoria.price          # Preco
puts melhoria.applicable_to  # Tipos de item aplicaveis

# Melhorias para armas
Tormenta20.melhorias.select do |m|
  m.applicable_to&.include?("arma")
end

# Melhorias para armaduras
Tormenta20.melhorias.select do |m|
  m.applicable_to&.include?("armadura")
end

# Melhorias ordenadas por preco
Tormenta20.melhorias.order(:price)
```
