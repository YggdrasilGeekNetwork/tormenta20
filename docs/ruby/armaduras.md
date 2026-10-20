# Armaduras

Armaduras leves e pesadas.

Acesso: `Tormenta20.armaduras` (`Tormenta20::Models::Armadura`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `category` | String | `leve` ou `pesada` |
| `price` | Float | Preço em T$ |
| `defense_bonus` | Integer | Bônus na Defesa |
| `armor_penalty` | Integer | Penalidade de armadura (valor negativo, ex.: `-3`) |
| `weight` | Float | Espaços |
| `properties` | Array | Regras especiais |
| `description` | String | Descrição |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `leves / pesadas` | Por categoria |
| `by_category(c)` | Por categoria |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `leve? / pesada?` | Categoria |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

Referências de página vêm do índice remissivo do livro básico; registros dos suplementos retornam `nil`.

## Exemplos

```ruby
Tormenta20.armaduras.leves.order(:defense_bonus)
Tormenta20.armaduras.where(armor_penalty: 0)

quitina = Tormenta20.armaduras.find("armadura_de_quitina")
puts "#{quitina.name}: +#{quitina.defense_bonus} Defesa, #{quitina.armor_penalty} de penalidade"
```
