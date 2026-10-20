# Poções

Poções, óleos e granadas, com faixas de rolagem para tesouro aleatório.

Acesso: `Tormenta20.pocoes` (`Tormenta20::Models::Pocao`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `subtipo` | String | `pocao`, `oleo` ou `granada` |
| `spell_id` | String | Magia reproduzida |
| `pm_cost` | Integer | Custo em PM do efeito |
| `categoria` | String | `menor`, `medio` ou `maior` |
| `preco` | Integer | Preço em T$ |
| `roll_min / roll_max` | Integer | Faixa na tabela de tesouro |
| `aprimoramento` | String | Aprimoramento aplicado, ou `nil` |
| `description` | String | Descrição |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `menores / medias / maiores` | Por categoria |
| `pocoes / oleos / granadas` | Por subtipo |
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
Tormenta20.pocoes.menores.pocoes.order(:preco)
pocao = Tormenta20.pocoes.find("alterar_tamanho")
Tormenta20.magias.find(pocao.spell_id)
```
