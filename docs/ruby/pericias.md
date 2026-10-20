# Perícias

As 29 perícias do livro básico.

Acesso: `Tormenta20.pericias` (`Tormenta20::Models::Pericia`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `atributo` | String | `FOR`, `DES`, `CON`, `INT`, `SAB` ou `CAR` |
| `trained_only` | Integer (0/1) | Somente treinada |
| `armor_penalty` | Integer (0/1) | Sofre penalidade de armadura |
| `resistance_skill` | Integer (0/1) | É teste de resistência |
| `description` | String | Descrição |
| `uses` | Array | Usos da perícia |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_atributo(attr)` | Por atributo |
| `trained_only` | Somente treinadas |
| `with_armor_penalty` | Com penalidade de armadura |
| `resistance_skills` | Testes de resistência |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `trained_only? / armor_penalty? / resistance_skill?` | Versões booleanas |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
Tormenta20.pericias.by_atributo("DES").pluck(:name)
Tormenta20.pericias.resistance_skills.pluck(:id)  # fortitude, reflexos, vontade
Tormenta20.pericias.find("acrobacia").armor_penalty?  # => true
```
