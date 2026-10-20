# Acessórios Mágicos

Acessórios mágicos (anéis, amuletos, capas…) com faixas de rolagem para tesouro aleatório.

Acesso: `Tormenta20.acessorios` (`Tormenta20::Models::AcessorioMagico`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `categoria` | String | `menor`, `medio` ou `maior` |
| `preco` | Integer | Preço em T$ |
| `roll_min / roll_max` | Integer | Faixa na tabela de tesouro |
| `description` | String | Descrição |
| `effects` | Array | Efeitos mecânicos |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `menores / medios / maiores` | Por categoria |
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
Tormenta20.acessorios.maiores.order(:preco)
Tormenta20.acessorios.find("amuleto_da_robustez").effects
```
