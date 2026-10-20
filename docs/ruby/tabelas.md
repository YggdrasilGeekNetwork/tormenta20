# Tabelas

Tabelas de referência e de rolagem (aparência, itens inteligentes, encontros aleatórios por terreno e região…).

Acesso: `Tormenta20.tabelas` (`Tormenta20::Models::Tabela`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `headers` | Array | Cabeçalhos das colunas |
| `rows` | Array | Linhas (Hash por cabeçalho) |
| `dice` | String | Dado de rolagem (ex.: `"1d100"`), ou `nil` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `sorteavel?` | Tem `dice` |
| `roll` | Rola o dado e retorna a linha correspondente |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
tabela = Tormenta20.tabelas.find("encontros_aquatico")
tabela.sorteavel?  # => true
tabela.roll        # ex.: { "Faixa" => "81-90", "Encontro" => "1 capitão pirata" }

Tormenta20.tabelas.where.not(dice: nil).pluck(:name)
```
