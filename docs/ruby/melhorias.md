# Melhorias

Melhorias de itens superiores.

Acesso: `Tormenta20.melhorias` (`Tormenta20::Models::Melhoria`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `applicable_to` | Array | Tipos de item aplicáveis (ex.: `["arma", "armadura"]`) |
| `price` | Integer | Preço, ou `nil` (o custo segue a tabela de itens superiores) |
| `effects` | Array | Efeitos mecânicos |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
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
Tormenta20.melhorias.find("inscrito").applicable_to
# => ["arma", "armadura", "escudo", "ferramenta", "vestuario"]

Tormenta20.melhorias.select { |m| m.applicable_to.include?("arma") }
```
