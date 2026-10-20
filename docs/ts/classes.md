# Classes — TypeScript

Classes de personagem: as 14 do livro básico, o Treinador (Heróis de Arton) e o Frade (Deuses de Arton).

```ts
import { Classe } from 'tormenta20'
```

> Os JSONs de classe ainda não trazem dados de conjuração: `spellcasting` é `nil` em todas as classes, então `conjuradores` retorna vazio e `conjurador?` retorna `false`.

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `hitPoints / manaPoints` | `Record<string, unknown>` | PV e PM brutos |
| `skills / proficiencies` | `Record<string, unknown>` | Perícias e proficiências brutas |
| `abilities / powers / progression` | `unknown[]` | Habilidades, poderes e progressão |
| `spellcasting` | `Record<string, unknown> \| null` | Dados de conjuração |
| `initialHp / hpPerLevel / mpPerLevel` | `number` | PV e PM |
| `mandatorySkills / availableSkills` | `unknown[]` | Perícias obrigatórias / à escolha |
| `chooseSkillsAmount` | `number` | Quantidade de perícias à escolha |
| `weaponProficiencies / armorProficiencies` | `string[]` | Proficiências |
| `shieldProficiency / isConjurador` | `boolean` | Escudos / conjuração |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `conjuradores()` | Classes com conjuração |

Para filtrar por livro: `Classe.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
const guerreiro = Classe.find("guerreiro")!
guerreiro.initialHp
Poder.byClass("guerreiro").all()
```
