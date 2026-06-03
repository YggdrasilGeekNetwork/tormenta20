# Raças

Acesso: `Tormenta20.racas`

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único (ex: `"anao"`) |
| `name` | String | Nome da raça |
| `description` | String | Descrição da raça |
| `size` | String | Tamanho (`"minúsculo"`, `"pequeno"`, `"médio"`, `"grande"`) |
| `movement` | Integer | Deslocamento em metros |
| `vision` | String | Tipo de visão (`"normal"`, `"baixa_luminosidade"`, `"visao_no_escuro"`) |
| `vision_range` | Integer / nil | Alcance da visão especial em metros |
| `attribute_bonuses` | Hash | Bônus de atributo por nome (`{ "constituicao" => 2 }`) |
| `skill_bonuses` | Array | Bônus em perícias |
| `racial_abilities` | Array | Habilidades raciais fixas |
| `chosen_abilities_amount` | Integer | Quantidade de habilidades a escolher |
| `available_chosen_abilities` | Array | Habilidades disponíveis para escolha |

## Métodos de Instância

```ruby
raca = Tormenta20.racas.find("anao")

# Bônus de atributo
raca.attribute_bonus_for("constituicao")  # => 2
raca.attribute_bonus_for("forca")         # => 0

# Tamanho
raca.minusculo?   # => false
raca.pequeno?     # => false
raca.grande?      # => false

# Visão
raca.visao_no_escuro?  # => true

# Conversão
raca.to_h  # Hash completo com todos os atributos
```

## Exemplos

```ruby
# Listar todas as raças
Tormenta20.racas.all.each do |r|
  puts "#{r.name} (#{r.size}) - Deslocamento: #{r.movement}m"
end

# Raças com visão no escuro
Tormenta20.racas.select(&:visao_no_escuro?).each do |r|
  puts "#{r.name}: #{r.vision_range}m de visão no escuro"
end

# Raças com bônus em Força
Tormenta20.racas.select { |r| r.attribute_bonus_for("forca") > 0 }

# Bônus de atributos de uma raça específica
elfo = Tormenta20.racas.find("elfo")
elfo.attribute_bonuses  # => { "destreza" => 2, ... }

# Raças pequenas
Tormenta20.racas.select(&:pequeno?)

# Referência de livro
Tormenta20.racas.find("minotauro").book_reference  # => "T20 - EJA, p. 25"
```
