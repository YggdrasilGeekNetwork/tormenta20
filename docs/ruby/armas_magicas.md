# Armas Mágicas Específicas

Armas mágicas específicas (itens com nome próprio).

Acesso: `Tormenta20.armas_magicas` (`Tormenta20::Models::ArmaMagicaEspecifica`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `base_weapon` | String | Id da arma base |
| `preco` | Integer | Preço em T$ |
| `description` | String | Descrição |
| `effects` | Array | Efeitos mecânicos |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_base(weapon_id)` | Por arma base |
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
Tormenta20.armas_magicas.by_base("adaga").pluck(:name)
Tormenta20.armas.find(Tormenta20.armas_magicas.find("adaga_da_bruma").base_weapon)
```
