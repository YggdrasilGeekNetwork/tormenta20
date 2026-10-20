# Encantamentos

Encantamentos de itens mágicos (armas, armaduras/escudos, esotéricos, acessórios), incluindo maldições.

Acesso: `Tormenta20.encantamentos` (`Tormenta20::Models::Encantamento`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `categoria` | String | `arma`, `armadura`, `esoterico` ou `acessorio` |
| `escudo_only` | Integer (0/1) | Só para escudos |
| `conta_como_dois` | Integer (0/1) | Conta como dois encantamentos |
| `maldicao` | Integer (0/1) | É maldição |
| `prerequisitos` | Array | Pré-requisitos |
| `effects` | Array | Efeitos mecânicos |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `armas` | Encantamentos de arma |
| `armaduras_escudos` | Encantamentos de armadura/escudo |
| `escudo_only` | Só para escudos |
| `maldicoes / nao_maldicoes` | Maldições / encantamentos normais |
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
Tormenta20.encantamentos.armas.nao_maldicoes.pluck(:name)
Tormenta20.encantamentos.maldicoes.count
Tormenta20.encantamentos.where(categoria: "acessorio")
```
