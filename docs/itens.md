# Itens

Acesso: `Tormenta20.itens`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome do item |
| `category` | String | Categoria do item |
| `price` | String | Preco |
| `weight` | String | Peso/espacos |
| `description` | String | Descricao |
| `effects` | Array | Efeitos do item |

## Scopes (Filtros)

### Por Categoria

```ruby
Tormenta20.itens.by_category("alquimico")
Tormenta20.itens.by_category("ferramenta")
Tormenta20.itens.by_category("vestuario")
```

## Metodos de Instancia

```ruby
item = Tormenta20.itens.first

item.to_h  # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todos os itens
Tormenta20.itens.all.each do |i|
  puts "#{i.name}: #{i.price}"
end

# Itens de uma categoria
Tormenta20.itens.by_category("alquimico").each do |i|
  puts "#{i.name}: #{i.description}"
end

# Buscar item especifico
item = Tormenta20.itens.find("corda")
puts item.name         # Nome
puts item.price        # Preco
puts item.description  # Descricao

# Itens ordenados por nome
Tormenta20.itens.order(:name)

# Agrupar itens por categoria
Tormenta20.itens.group(:category).count
```
