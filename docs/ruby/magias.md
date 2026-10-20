# Magias

Magias arcanas, divinas e universais do livro básico e dos suplementos.

Acesso: `Tormenta20.magias` (`Tormenta20::Models::Magia`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `type` | String | `arcana`, `divina` ou `universal` |
| `circle` | String | Círculo, como string (`"1"`–`"5"`) |
| `school` | String | Escola (`abjur`, `adiv`, `conv`, `encan`, `evoc`, `ilus`, `necro`, `trans`) |
| `execution / execution_details` | String | Tempo de execução |
| `range` | String | Alcance |
| `duration / duration_details` | String | Duração |
| `counterspell` | String | Id da contramágica, ou `nil` |
| `description` | String | Descrição |
| `target_amount / target_up_to / target_type` | Integer / Integer (0/1) / String | Alvo |
| `effect / effect_shape / effect_dimention / effect_size / effect_other_details` | String | Área ou efeito |
| `resistence_effect / resistence_skill` | String | Teste de resistência |
| `extra_costs_material_component / extra_costs_material_cost / extra_costs_pm_debuff / extra_costs_pm_sacrifice` | String | Custos extras |
| `enhancements` | Array | Aprimoramentos |
| `effects` | Array | Efeitos mecânicos tipados |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `arcanas / divinas / universais` | Por tradição |
| `by_type(type)` | Por tradição |
| `by_circle(circle)` | Por círculo (aceita Integer ou String) |
| `by_school(school)` | Por escola |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `target_info` | `{ amount:, up_to:, type: }` ou `nil` |
| `effect_details_info` | `{ shape:, dimention:, size:, other_details: }` ou `nil` |
| `resistence_info` | `{ effect:, skill: }` ou `nil` |
| `extra_costs_info` | Custos extras preenchidos, ou `nil` |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
Tormenta20.magias.arcanas.by_circle(3)
Tormenta20.magias.by_school("evoc").order(:name)
Tormenta20.magias.do_livro("deuses_de_arton").count

bola = Tormenta20.magias.find("bola_de_fogo")
bola.target_info
bola.resistence_info[:skill]  # => "reflexos"
```
