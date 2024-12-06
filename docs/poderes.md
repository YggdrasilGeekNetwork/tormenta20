# Poderes

Acesso: `Tormenta20.poderes`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome do poder |
| `type` | String | Tipo do poder |
| `description` | String | Descricao |
| `effects` | Array | Efeitos do poder |
| `prerequisites` | Array | Pre-requisitos |
| `origin_id` | String | ID da origem associada (se aplicavel) |
| `deities` | Array | Divindades que concedem (se aplicavel) |

## Tipos de Poder

| Tipo | Descricao |
|------|-----------|
| `habilidade_unica_origem` | Habilidades unicas de origem |
| `poder_concedido` | Poderes concedidos por divindades |
| `poder_tormenta` | Poderes da Tormenta |
| `poder_classe` | Poderes de classe |
| `poder_geral` | Poderes gerais |
| `poder_combate` | Poderes de combate |
| `poder_destino` | Poderes de destino |
| `poder_magia` | Poderes de magia |

## Scopes (Filtros)

### Por Tipo

```ruby
Tormenta20.poderes.habilidades_unicas   # Habilidades unicas de origem
Tormenta20.poderes.poderes_concedidos   # Poderes concedidos por divindades
Tormenta20.poderes.poderes_tormenta     # Poderes da Tormenta
Tormenta20.poderes.poderes_classe       # Poderes de classe
Tormenta20.poderes.poderes_gerais       # Poderes gerais
Tormenta20.poderes.by_type("poder_combate")
```

### Por Origem

```ruby
Tormenta20.poderes.by_origin("soldado")  # Poderes da origem Soldado
```

### Por Divindade

```ruby
Tormenta20.poderes.by_deity("khalmyr")  # Poderes concedidos por Khalmyr
```

## Metodos de Instancia

```ruby
poder = Tormenta20.poderes.find("ataque_poderoso")

poder.to_h  # Converte para Hash completo
```

## Exemplos

```ruby
# Listar todos os poderes
Tormenta20.poderes.all.each do |p|
  puts "#{p.name} (#{p.type})"
end

# Poderes concedidos por divindades
Tormenta20.poderes.poderes_concedidos.each do |p|
  puts "#{p.name}: #{p.deities&.join(', ')}"
end

# Poderes da Tormenta
Tormenta20.poderes.poderes_tormenta.each do |p|
  puts "#{p.name}: #{p.description}"
end

# Habilidades unicas de uma origem especifica
Tormenta20.poderes.habilidades_unicas.by_origin("soldado").each do |p|
  puts p.name
end

# Poderes com pre-requisitos
Tormenta20.poderes.where.not(prerequisites: nil).each do |p|
  puts "#{p.name}: requer #{p.prerequisites}"
end

# Contar poderes por tipo
Tormenta20.poderes.group(:type).count
# => {"poder_concedido"=>50, "habilidade_unica_origem"=>35, ...}

# Buscar poderes por nome
Tormenta20.poderes.where("name LIKE ?", "%Furia%")
```
