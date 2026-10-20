# Raças

Raças jogáveis do livro básico, de Heróis de Arton e as raças de Ameaças de Arton.

Acesso: `Tormenta20.racas` (`Tormenta20::Models::Raca`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `size` | String | `minúsculo`, `pequeno`, `médio`, `grande` |
| `movement` | Integer | Deslocamento em metros |
| `vision / vision_range` | String / Integer | Tipo e alcance de visão |
| `attribute_bonuses` | Hash | Bônus fixos (ex.: `{ "DES" => 2 }`) |
| `chosen_attribute_bonus` | Hash / nil | Bônus à escolha: `{ count, value, exclude }` |
| `skill_bonuses` | Array | Bônus de perícia |
| `racial_abilities` | Array | Ids das habilidades raciais |
| `chosen_abilities_amount / available_chosen_abilities` | Integer / Array | Habilidades à escolha |
| `longevidade` | String | Longevidade (ex.: `"x2"`) |
| `devocao` | Array / nil | Divindades comuns |
| `ability_swap` | Hash / nil | Troca de habilidade: `{ replaces, options }` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `attribute_bonus_for(attr)` | Bônus fixo em um atributo |
| `minusculo? / pequeno? / grande?` | Tamanho |
| `visao_no_escuro?` | Tem visão no escuro |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

Referências de página vêm do índice remissivo do livro básico; registros dos suplementos retornam `nil`.

## Exemplos

```ruby
anao = Tormenta20.racas.find("anao")
anao.attribute_bonus_for("CON")
anao.racial_abilities.map { |id| Tormenta20.poderes.find(id).name }
anao.book_reference  # => "T20 - EJA, p. 20"

Tormenta20.racas.do_livro("ameacas_de_arton").pluck(:name)
```
