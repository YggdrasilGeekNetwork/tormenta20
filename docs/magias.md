# Magias (Spells)

Acesso: `Tormenta20.magias`

## Atributos

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `id` | String | Identificador unico |
| `name` | String | Nome da magia |
| `type` | String | Tipo: `arcana`, `divina`, `universal` |
| `circle` | String | Circulo (1-5) |
| `school` | String | Escola de magia |
| `execution` | String | Tempo de execucao |
| `execution_details` | String | Detalhes da execucao |
| `range` | String | Alcance |
| `duration` | String | Duracao |
| `duration_details` | String | Detalhes da duracao |
| `description` | String | Descricao completa |
| `counterspell` | String | Contramagia |
| `enhancements` | Array | Aprimoramentos disponiveis |
| `effects` | Array | Efeitos da magia |

### Atributos de Alvo

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `target_amount` | Integer | Quantidade de alvos |
| `target_up_to` | Boolean | Ate X alvos |
| `target_type` | String | Tipo de alvo |

### Atributos de Efeito

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `effect` | String | Efeito principal |
| `effect_shape` | String | Forma do efeito |
| `effect_dimention` | String | Dimensao |
| `effect_size` | String | Tamanho |
| `effect_other_details` | String | Outros detalhes |
| `area_effect` | String | Efeito de area |
| `area_effect_details` | String | Detalhes da area |

### Atributos de Resistencia

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `resistence_effect` | String | Efeito da resistencia |
| `resistence_skill` | String | Pericia para resistencia |

### Atributos de Custo Extra

| Atributo | Tipo | Descricao |
|----------|------|-----------|
| `extra_costs_material_component` | String | Componente material |
| `extra_costs_material_cost` | String | Custo do componente |
| `extra_costs_pm_debuff` | Integer | Debuff de PM |
| `extra_costs_pm_sacrifice` | Integer | Sacrificio de PM |

## Scopes (Filtros)

### Por Tipo

```ruby
Tormenta20.magias.arcanas      # Magias arcanas
Tormenta20.magias.divinas      # Magias divinas
Tormenta20.magias.universais   # Magias universais
Tormenta20.magias.by_type("arcana")
```

### Por Circulo

```ruby
Tormenta20.magias.by_circle("1")   # Magias do 1o circulo
Tormenta20.magias.by_circle("5")   # Magias do 5o circulo
Tormenta20.magias.do_circulo("3")  # Alias em portugues
```

### Por Escola

```ruby
Tormenta20.magias.by_school("evoc")    # Evocacao
Tormenta20.magias.by_school("abjur")   # Abjuracao
Tormenta20.magias.by_school("adiv")    # Adivinhacao
Tormenta20.magias.by_school("conv")    # Convocacao
Tormenta20.magias.by_school("encan")   # Encantamento
Tormenta20.magias.by_school("ilus")    # Ilusao
Tormenta20.magias.by_school("necro")   # Necromancia
Tormenta20.magias.by_school("trans")   # Transmutacao
Tormenta20.magias.da_escola("evoc")    # Alias em portugues
```

### Combinando Filtros

```ruby
# Magias arcanas do 3o circulo
Tormenta20.magias.arcanas.by_circle("3")

# Magias divinas de necromancia
Tormenta20.magias.divinas.by_school("necro")

# Magias universais do 1o circulo de abjuracao
Tormenta20.magias.universais.by_circle("1").by_school("abjur")
```

## Metodos de Classe

```ruby
Tormenta20.magias.todas           # Todas as magias (alias para .all)
Tormenta20.magias.arcanas_list    # Lista de arcanas
Tormenta20.magias.divinas_list    # Lista de divinas
Tormenta20.magias.universais_list # Lista de universais
```

## Metodos de Instancia

```ruby
magia = Tormenta20.magias.find("bola_de_fogo")

magia.target_info          # Hash com info do alvo
# => { amount: 1, up_to: false, type: "criatura" }

magia.effect_details_info  # Hash com detalhes do efeito
# => { shape: "esfera", size: "6m" }

magia.resistence_info      # Hash com info de resistencia
# => { effect: "reduz", skill: "Reflexos" }

magia.extra_costs_info     # Hash com custos extras
# => { material_component: "enxofre", material_component_cost: "T$ 10" }

magia.to_h                 # Converte para Hash completo
```

## Exemplos

```ruby
# Buscar magia especifica
bola_de_fogo = Tormenta20.magias.find("bola_de_fogo")
puts bola_de_fogo.name        # => "Bola de Fogo"
puts bola_de_fogo.circle      # => "3"
puts bola_de_fogo.school      # => "evoc"

# Listar todas as magias de cura
Tormenta20.magias.where("name LIKE ?", "%Cura%").each do |m|
  puts "#{m.name} (#{m.type}, #{m.circle}o circulo)"
end

# Magias arcanas ordenadas por circulo
Tormenta20.magias.arcanas.order(:circle, :name).each do |m|
  puts "#{m.circle}o - #{m.name}"
end

# Contar magias por escola
Tormenta20.magias.group(:school).count
# => {"evoc"=>25, "abjur"=>15, ...}
```
