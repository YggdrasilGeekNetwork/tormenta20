# Complicações

Complicações de Heróis de Arton: desvantagens gerais e específicas de classe.

Acesso: `Tormenta20.complicacoes` (`Tormenta20::Models::Complicacao`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `categoria` | String | `geral` ou id de classe |
| `effects` | Array | Efeitos mecânicos |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `gerais` | Complicações gerais |
| `by_categoria(categoria)` | Por categoria (ex.: id de classe) |
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
Tormenta20.complicacoes.gerais.pluck(:name)
Tormenta20.complicacoes.by_categoria("arcanista")
Tormenta20.complicacoes.find("amaldicoado").effects
```
