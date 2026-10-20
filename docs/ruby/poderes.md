# Poderes

Todos os poderes e habilidades: de classe, raça, origem, concedidos, da Tormenta, gerais (combate, destino, magia), de raça, de grupo e de distinção.

Acesso: `Tormenta20.poderes` (`Tormenta20::Models::Poder`)

> Os poderes gerais são classificados pelo subtipo (`poder_combate`, `poder_destino`, `poder_magia`, `poder_de_raca`, `poder_de_grupo`). Nenhum registro usa `poder_geral`, então `poderes_gerais` retorna vazio.

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `type` | String | `poder_classe`, `habilidade_de_raca`, `habilidade_unica_origem`, `poder_concedido`, `poder_tormenta`, `poder_combate`, `poder_destino`, `poder_magia`, `poder_de_raca`, `poder_de_grupo`, `poder_distincao` |
| `description` | String | Descrição |
| `effects` | Array / Hash / String | Efeitos mecânicos (formato varia; `"ver_texto"` quando só há texto) |
| `costs` | Array | Custos de ativação (ex.: `[{ "value" => 1, "type" => "PM" }]`) |
| `prerequisites` | Array / String | Pré-requisitos |
| `origin_id` | String | Origem associada (habilidades únicas) |
| `class_id` | String | Classe associada (poderes de classe) |
| `distincao_id` | String | Distinção associada (poderes de distinção) |
| `deities` | Array | Ids das divindades que concedem o poder |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_type(type)` | Por tipo |
| `poderes_classe / habilidades_de_raca / habilidades_unicas` | Classe, raça, origem |
| `poderes_concedidos / poderes_tormenta` | Concedidos e da Tormenta |
| `poderes_combate / poderes_destino / poderes_magia` | Gerais por subtipo |
| `poderes_de_raca / poderes_de_grupo / poderes_distincao` | Heróis/Deuses de Arton |
| `by_class(class_id) / by_origin(origin_id) / by_distincao(distincao_id)` | Por dono |
| `by_deity(deity_id)` | Concedidos por uma divindade |
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
Tormenta20.poderes.by_class("arcanista").count
Tormenta20.poderes.poderes_combate.order(:name)
Tormenta20.poderes.by_distincao("amazona")
Tormenta20.poderes.by_deity("khalmyr")

barreira = Tormenta20.poderes.find("barreira_mistica")
barreira.costs  # => [{ "value" => 1, "type" => "PM" }]
```
