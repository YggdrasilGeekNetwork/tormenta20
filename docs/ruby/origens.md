# Origens

Origens de personagem: as do livro básico e de Heróis de Arton, mais as 66 origens regionais do Atlas de Arton (a região aparece no início da descrição).

Acesso: `Tormenta20.origens` (`Tormenta20::Models::Origem`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `items` | Array | Itens iniciais |
| `benefits` | Hash | `skills` e `powers` oferecidos |
| `unique_power` | String | Id do poder único, ou `nil` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `with_unique_power` | Origens com poder único |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `skills` | Ids de perícias oferecidas |
| `powers` | Ids de poderes oferecidos |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

Referências de página vêm do índice remissivo do livro básico; registros dos suplementos retornam `nil`.

## Exemplos

```ruby
acolito = Tormenta20.origens.find("acolito")
acolito.skills
acolito.powers
Tormenta20.poderes.find(acolito.unique_power)

Tormenta20.origens.do_livro("atlas_de_arton").count  # => 66
```
