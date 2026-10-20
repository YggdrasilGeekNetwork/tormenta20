# Classes

Classes de personagem: as 14 do livro básico, o Treinador (Heróis de Arton) e o Frade (Deuses de Arton).

Acesso: `Tormenta20.classes` (`Tormenta20::Models::Classe`)

> Os JSONs de classe ainda não trazem dados de conjuração: `spellcasting` é `nil` em todas as classes, então `conjuradores` retorna vazio e `conjurador?` retorna `false`.

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `hit_points` | Hash | `{ "initial" =>, "per_level" => }` |
| `mana_points` | Hash | `{ "per_level" => }` |
| `skills` | Hash | `mandatory`, `choose_amount`, `choose_from` |
| `proficiencies` | Hash | `weapons`, `armors`, `shields` |
| `abilities` | Array | Habilidades de classe por nível |
| `powers` | Array | Poderes liberados por nível |
| `progression` | Array | Tabela de progressão |
| `spellcasting` | Hash / nil | Dados de conjuração, `nil` para não conjuradores |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `conjuradores` | Classes com conjuração |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `initial_hp / hp_per_level / mp_per_level` | PV e PM |
| `mandatory_skills / choose_skills_amount / available_skills` | Perícias |
| `weapon_proficiencies / armor_proficiencies / shield_proficiency?` | Proficiências |
| `conjurador?` | Tem conjuração |
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

Referências de página vêm do índice remissivo do livro básico; registros dos suplementos retornam `nil`.

## Exemplos

```ruby
guerreiro = Tormenta20.classes.find("guerreiro")
guerreiro.initial_hp            # => 20
guerreiro.weapon_proficiencies

# Poderes da classe
Tormenta20.poderes.by_class("guerreiro")
# Variantes (Heróis de Arton)
Tormenta20.classes_variantes.by_base("guerreiro")
```
