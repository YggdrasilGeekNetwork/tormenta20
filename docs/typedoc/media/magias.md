# Magias (Spells)

Acesso: `Tormenta20.magias`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome da magia |
| `type` | String | Tipo: `arcana`, `divina`, `universal` |
| `circle` | String | Círculo (1-5) |
| `school` | String | Escola de magia |
| `execution` | String | Tempo de execução |
| `execution_details` | String | Detalhes da execução |
| `range` | String | Alcance |
| `duration` | String | Duração |
| `duration_details` | String | Detalhes da duração |
| `description` | String | Descrição completa |
| `counterspell` | String | Contramagia |
| `enhancements` | Array | Aprimoramentos disponíveis |
| `effects` | Array | Efeitos da magia |

### Atributos de Alvo

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `target_amount` | Integer | Quantidade de alvos |
| `target_up_to` | Boolean | Até X alvos |
| `target_type` | String | Tipo de alvo |

### Atributos de Efeito

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `effect` | String | Efeito principal |
| `effect_shape` | String | Forma do efeito |
| `effect_dimention` | String | Dimensão |
| `effect_size` | String | Tamanho |
| `effect_other_details` | String | Outros detalhes |
| `area_effect` | String | Efeito de área |
| `area_effect_details` | String | Detalhes da área |

### Atributos de Resistência

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `resistence_effect` | String | Efeito da resistência |
| `resistence_skill` | String | Perícia para resistência |

### Atributos de Custo Extra

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `extra_costs_material_component` | String | Componente material |
| `extra_costs_material_cost` | String | Custo do componente |
| `extra_costs_pm_debuff` | Integer | Debuff de PM |
| `extra_costs_pm_sacrifice` | Integer | Sacrifício de PM |

## Scopes (Filtros)

### Por Tipo

```ruby
Tormenta20.magias.arcanas      # Magias arcanas
Tormenta20.magias.divinas      # Magias divinas
Tormenta20.magias.universais   # Magias universais
Tormenta20.magias.by_type("arcana")
```

### Por Círculo

```ruby
Tormenta20.magias.by_circle("1")   # Magias do 1º círculo
Tormenta20.magias.by_circle("5")   # Magias do 5º círculo
Tormenta20.magias.do_circulo("3")  # Alias em português
```

### Por Escola

```ruby
Tormenta20.magias.by_school("evoc")    # Evocação
Tormenta20.magias.by_school("abjur")   # Abjuração
Tormenta20.magias.by_school("adiv")    # Adivinhação
Tormenta20.magias.by_school("conv")    # Convocação
Tormenta20.magias.by_school("encan")   # Encantamento
Tormenta20.magias.by_school("ilus")    # Ilusão
Tormenta20.magias.by_school("necro")   # Necromancia
Tormenta20.magias.by_school("trans")   # Transmutação
Tormenta20.magias.da_escola("evoc")    # Alias em português
```

### Combinando Filtros

```ruby
# Magias arcanas do 3º círculo
Tormenta20.magias.arcanas.by_circle("3")

# Magias divinas de necromancia
Tormenta20.magias.divinas.by_school("necro")

# Magias universais do 1º círculo de abjuração
Tormenta20.magias.universais.by_circle("1").by_school("abjur")
```

## Métodos de Classe

```ruby
Tormenta20.magias.todas           # Todas as magias (alias para .all)
Tormenta20.magias.arcanas_list    # Lista de arcanas
Tormenta20.magias.divinas_list    # Lista de divinas
Tormenta20.magias.universais_list # Lista de universais
```

## Métodos de Instância

```ruby
magia = Tormenta20.magias.find("bola_de_fogo")

magia.target_info          # Hash com info do alvo
# => { amount: 1, up_to: false, type: "criatura" }

magia.effect_details_info  # Hash com detalhes do efeito
# => { shape: "esfera", size: "6m" }

magia.resistence_info      # Hash com info de resistência
# => { effect: "reduz", skill: "Reflexos" }

magia.extra_costs_info     # Hash com custos extras
# => { material_component: "enxofre", material_component_cost: "T$ 10" }

magia.to_h                 # Converte para Hash completo
```

## Exemplos

```ruby
# Buscar magia específica
bola_de_fogo = Tormenta20.magias.find("bola_de_fogo")
puts bola_de_fogo.name        # => "Bola de Fogo"
puts bola_de_fogo.circle      # => "3"
puts bola_de_fogo.school      # => "evoc"

# Listar todas as magias de cura
Tormenta20.magias.where("name LIKE ?", "%Cura%").each do |m|
  puts "#{m.name} (#{m.type}, #{m.circle}º círculo)"
end

# Magias arcanas ordenadas por círculo
Tormenta20.magias.arcanas.order(:circle, :name).each do |m|
  puts "#{m.circle}º - #{m.name}"
end

# Contar magias por escola
Tormenta20.magias.group(:school).count
# => {"evoc"=>25, "abjur"=>15, ...}
```
