# Distinções

Distinções de Heróis de Arton e Deuses de Arton. Os poderes de cada distinção ficam em `Poder` com `type: "poder_distincao"`.

Acesso: `Tormenta20.distincoes` (`Tormenta20::Models::Distincao`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `admissao` | String | Requisitos de admissão |
| `marca_nome` | String | Nome da Marca da Distinção |
| `marca_descricao` | String | Efeito da Marca |
| `nivel_minimo` | Integer | Nível mínimo (veterano = 5) |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `poderes` | Poderes da distinção (`has_many`) |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
amazona = Tormenta20.distincoes.find("amazona")
amazona.marca_nome  # => "Armadura das Amazonas"
amazona.poderes.pluck(:name)
Tormenta20.distincoes.do_livro("deuses_de_arton")
```
