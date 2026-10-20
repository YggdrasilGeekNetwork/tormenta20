# Armas

Armas simples, marciais, exóticas e de fogo.

Acesso: `Tormenta20.armas` (`Tormenta20::Models::Arma`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `category` | String | `simples`, `marciais`, `exoticas` ou `fogo` |
| `price` | Float | Preço em T$ |
| `damage` | String | Dano (ex.: `"1d8"`) |
| `damage_type` | String | `corte`, `perfuracao`, `impacto` (ou lista JSON) |
| `critical` | String | Crítico |
| `range` | String | Alcance, ou `nil` para corpo a corpo |
| `weight` | Float | Espaços |
| `properties` | Array | Habilidades da arma e regras especiais |
| `description` | String | Descrição |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `simples / marciais / exoticas / fogo` | Por categoria |
| `by_category(c)` | Por categoria |
| `by_damage_type(t)` | Por tipo de dano |
| `melee / ranged` | Corpo a corpo / à distância |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `ranged?` | Tem alcance |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

Referências de página vêm do índice remissivo do livro básico; registros dos suplementos retornam `nil`.

## Exemplos

```ruby
Tormenta20.armas.marciais.melee.order(:name)
chicote = Tormenta20.armas.find("chicote")
chicote.properties  # ["agil", "versatil", { "alcance_ataque" => 4.5, ... }]
```
