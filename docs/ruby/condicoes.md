# Condições

Condições de status do livro básico.

Acesso: `Tormenta20.condicoes` (`Tormenta20::Models::Condicao`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `effects` | Array | Efeitos mecânicos |
| `condition_type` | String | Tipo (`medo`, `mental`, `metabolismo`, `movimento`, `veneno`, `sentidos`, `cansaco`, `metamorfose`) |
| `escalates_to` | String | Id da condição mais grave, ou `nil` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_type(type)` | Por tipo |
| `medo / mental / metabolismo / movimento` | Atalhos por tipo |
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
fatigado = Tormenta20.condicoes.find("fatigado")
fatigado.escalates_to  # => "exausto"
fatigado.book_reference
Tormenta20.condicoes.medo.pluck(:name)
```
