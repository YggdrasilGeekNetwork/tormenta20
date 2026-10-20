# Divindades

Deuses maiores do Panteão e deuses menores de Deuses de Arton.

Acesso: `Tormenta20.divindades` (`Tormenta20::Models::Divindade`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `title` | String | Título ou epíteto |
| `description` | String | Descrição |
| `beliefs_objectives` | Array | Crenças e objetivos |
| `holy_symbol` | String | Símbolo sagrado |
| `energy` | String | `positiva`, `negativa` ou `qualquer` |
| `preferred_weapon` | String | Id da arma preferida |
| `devotees` | Hash | `races` e `classes` devotas |
| `granted_powers` | Array | Ids dos poderes concedidos |
| `obligations_restrictions` | String | Obrigações e restrições |
| `rank` | String | `maior` ou `menor` |
| `natureza` | String | Natureza do deus menor, ou `nil` |
| `status_divino` | Integer | Status divino (1–5) do deus menor, ou `nil` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `energia_positiva / energia_negativa / energia_qualquer` | Por energia |
| `by_energy(energy)` | Por energia |
| `maiores / menores` | Por posição no Panteão |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `races` | Ids das raças devotas |
| `classes` | Ids das classes devotas |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

Referências de página vêm do índice remissivo do livro básico; registros dos suplementos retornam `nil`.

## Exemplos

```ruby
khalmyr = Tormenta20.divindades.find("khalmyr")
khalmyr.granted_powers
Tormenta20.poderes.by_deity("khalmyr")
Tormenta20.divindades.menores.pluck(:name)
Tormenta20.itens_liturgicos.by_deity("khalmyr")
```
