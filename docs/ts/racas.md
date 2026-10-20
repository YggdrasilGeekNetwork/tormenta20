# Raças — TypeScript

Raças jogáveis do livro básico, de Heróis de Arton e as raças de Ameaças de Arton.

```ts
import { Raca } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string` | Descrição |
| `size` | `RacaSize` | Tamanho |
| `movement` | `number` | Deslocamento em metros |
| `vision / visionRange` | `RacaVision` / `number \| null` | Tipo e alcance de visão |
| `attributeBonuses` | `Record<string, number>` | Bônus fixos |
| `chosenAttributeBonus` | `{ count, value, exclude? } \| null` | Bônus à escolha |
| `skillBonuses` | `unknown[]` | Bônus de perícia |
| `racialAbilities` | `string[]` | Ids das habilidades raciais |
| `chosenAbilitiesAmount / availableChosenAbilities` | `number` / `unknown[]` | Habilidades à escolha |
| `longevidade` | `string \| null` | Longevidade |
| `devocao` | `string[] \| null` | Divindades comuns |
| `abilitySwap` | `{ replaces, options } \| null` | Troca de habilidade |
| `isMinusculo / isPequeno / isGrande / hasVisaoNoEscuro` | `boolean` | Atalhos |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |

Para filtrar por livro: `Raca.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `attributeBonusFor(attr)` | Bônus fixo em um atributo |
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
const anao = Raca.find("anao")!
anao.attributeBonusFor("CON")
anao.bookReference()?.formatted  // "T20 - EJA, p. 20"
Raca.query().where("livro_id = ?", "ameacas_de_arton").all()
```
