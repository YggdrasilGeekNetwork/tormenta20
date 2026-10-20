# Ameaças

Bestiário: as criaturas do livro básico, de Deuses de Arton e de Ameaças de Arton (incluindo montarias, mascotes e familiares).

Acesso: `Tormenta20.ameacas` (`Tormenta20::Models::Ameaca`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `nd` | Float | Nível de Desafio (ND 1/4 = `0.25`) |
| `tipo / subtipo` | String | Tipo e subtipo da criatura |
| `tamanho` | String | Categoria de tamanho |
| `grupo` | String | Grupo temático (ex.: `dragoes`, `ermos`, `montarias`) |
| `pv / defesa / pm` | Integer | PV, Defesa e PM |
| `for / des / con / int / sab / car` | Integer | Atributos (use `atributos`; `for` e `int` exigem `self[:for]`) |
| `iniciativa / percepcao` | Integer | Bônus |
| `deslocamento` | String (JSON) | Deslocamentos, ex.: `{"terrestre":12,"voo":24}` |
| `visao` | String (JSON) | Lista de sentidos |
| `salvaguardas` | Hash | `fort`, `ref`, `von` |
| `ataques / poderes_especiais` | Array | Ataques e habilidades especiais |
| `imunidades / vulnerabilidades` | Array | Imunidades e vulnerabilidades |
| `resistencias` | Hash | Resistências por tipo de dano |
| `reducao_de_dano / cura_acelerada` | Integer / String | Ex.: `10` ou `"10/luz"` |
| `resistencia_a_magia` | Integer | Resistência a magia |
| `pericias` | Hash | Bônus de perícias |
| `equipamento` | Array | Equipamento (texto) |
| `tesouro` | String | Tesouro |
| `description` | String | Descrição |
| `familiar` | String | Benefício como familiar, ou `nil` |
| `parceiro` | Hash / nil | Benefícios como parceiro: `{ tipo, restricao, iniciante, veterano, mestre }` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_grupo(grupo)` | Por grupo |
| `by_nd(nd) / up_to_nd(nd)` | ND exato / até um ND |
| `masmorras / ermos / puristas / reino_dos_mortos / duyshidakk / sszzaazitas / trolls_nobres / dragoes / tormenta / avatares` | Atalhos de grupo |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `atributos` | `{ for:, des:, con:, int:, sab:, car: }` |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
Tormenta20.ameacas.up_to_nd(2).by_grupo("ermos").order(:nd)
Tormenta20.ameacas.by_grupo("montarias").pluck(:name)

dragao = Tormenta20.ameacas.find("dragao_rei")
dragao.atributos
JSON.parse(dragao.deslocamento)  # => { "terrestre" => 12, "voo" => 24 }

Tormenta20.ameacas.find("avatar_de_megalokk").cura_acelerada  # => "100/kaiju"
Tormenta20.ameacas.find("homunculo").parceiro
```
