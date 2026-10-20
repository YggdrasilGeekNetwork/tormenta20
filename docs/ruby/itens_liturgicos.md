# Itens Litúrgicos

Itens litúrgicos de Deuses de Arton, ligados a uma ou mais divindades.

Acesso: `Tormenta20.itens_liturgicos` (`Tormenta20::Models::ItemLiturgico`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `deities` | Array | Ids das divindades associadas |
| `subtipo` | String | `arma`, `armadura` ou `acessorio` |
| `base_item` | String | Item base, quando houver |
| `classificacao` | String | Classificação no livro (ex.: `"Arma específica menor"`) |
| `preco` | Integer | Preço em T$ |
| `description` | String | Descrição |
| `effects` | Array | Efeitos mecânicos |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_deity(deity_id)` | Por divindade |
| `by_subtipo(subtipo)` | Por subtipo |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
Tormenta20.itens_liturgicos.by_deity("lin_wu").pluck(:name)
Tormenta20.itens_liturgicos.by_subtipo("arma")
```
