# Classes Variantes

Variantes de classe de Heróis de Arton (ex.: Alquimista, variante do Inventor). Cada variante descreve as diferenças por nível em relação à classe base.

Acesso: `Tormenta20.classes_variantes` (`Tormenta20::Models::ClasseVariante`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `base_class_id` | String | Id da classe base |
| `description` | String | Descrição |
| `diffs` | Array | Diferenças por nível: `{ nivel, remove, adiciona }` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_base(class_id)` | Variantes de uma classe base |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `base_classe` | Registro `Classe` base |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
alquimista = Tormenta20.classes_variantes.find("alquimista")
alquimista.base_classe.name  # => "Inventor"
alquimista.diffs
Tormenta20.classes_variantes.by_base("bucaneiro").pluck(:name)
```
