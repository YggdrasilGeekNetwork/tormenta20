# Materiais Especiais

Materiais especiais (adamante, mitral, aço-rubi…), do livro básico e de Ameaças de Arton.

Acesso: `Tormenta20.materiais_especiais` (`Tormenta20::Models::MaterialEspecial`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `applicable_to` | Array | Reservado, sempre `[]` (os tipos de item estão nas chaves de `price_modifier`) |
| `price_modifier` | Hash | Preço adicional por tipo de item (ex.: `{ "arma" => 3000, "armadura_leve" => 6000 }`) |
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

Referências de página vêm do índice remissivo do livro básico; registros dos suplementos retornam `nil`.

## Exemplos

```ruby
adamante = Tormenta20.materiais_especiais.find("adamante")
adamante.price_modifier["arma"]  # => 3000

# Materiais que podem ser usados em armas
Tormenta20.materiais_especiais.select { |m| m.price_modifier.key?("arma") }
```
