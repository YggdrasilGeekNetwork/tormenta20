# Condições

Acesso: `Tormenta20.condicoes`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único (ex: `"abalado"`) |
| `name` | String | Nome da condição |
| `description` | String | Descrição completa da condição |
| `effects` | Array | Lista de efeitos mecânicos |
| `condition_type` | String / nil | Categoria da condição (ver abaixo) |
| `escalates_to` | String / nil | ID da condição para a qual esta escala ao ser reaplicada |

### Tipos de Condição (`condition_type`)

| Tipo | Descrição |
|------|-----------|
| `medo` | Condições de medo (abalado, apavorado) |
| `mental` | Condições mentais (fascinado, confuso) |
| `metabolismo` | Condições metabólicas (envenenado, doente) |
| `movimento` | Condições de movimento (lento, imóvel, paralisado) |
| `veneno` | Condições de veneno |
| `sentidos` | Condições de sentido (cego, surdo) |
| `cansaco` | Condições de fadiga (fatigado, exausto) |
| `metamorfose` | Condições de metamorfose (petrificado) |

## Scopes (Filtros)

```ruby
Tormenta20.condicoes.by_type("medo")    # Filtro genérico por tipo
Tormenta20.condicoes.medo               # Condições de medo
Tormenta20.condicoes.mental             # Condições mentais
Tormenta20.condicoes.metabolismo        # Condições metabólicas
Tormenta20.condicoes.movimento          # Condições de movimento
```

## Métodos de Instância

```ruby
condicao = Tormenta20.condicoes.find("abalado")

condicao.name           # => "Abalado"
condicao.description    # Texto completo
condicao.effects        # => ["...", "..."]
condicao.condition_type # => "medo"
condicao.escalates_to   # => "apavorado" (ou nil)

condicao.to_h           # Hash completo
```

## Exemplos

```ruby
# Listar todas as condições
Tormenta20.condicoes.all.each do |c|
  puts c.name
end

# Condições que escalam para outra
Tormenta20.condicoes.select { |c| c.escalates_to.present? }.each do |c|
  puts "#{c.name} → #{c.escalates_to}"
end

# Condições de medo em ordem de gravidade
Tormenta20.condicoes.medo.each do |c|
  puts "#{c.name}: #{c.effects.first}"
end

# Efeitos de uma condição específica
paralisado = Tormenta20.condicoes.find("paralisado")
paralisado.effects.each { |e| puts "- #{e}" }

# Referência de livro
Tormenta20.condicoes.find("abalado").book_reference  # => "T20 - EJA, p. 394"
```
