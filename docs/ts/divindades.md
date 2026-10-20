# Divindades — TypeScript

Deuses maiores do Panteão e deuses menores de Deuses de Arton.

```ts
import { Divindade } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `title` | `string \| null` | Título ou epíteto |
| `description` | `string \| null` | Descrição |
| `beliefsObjectives` | `unknown[]` | Crenças e objetivos |
| `holySymbol` | `string \| null` | Símbolo sagrado |
| `energy` | `DivindadeEnergy` | `positiva`, `negativa` ou `qualquer` |
| `preferredWeapon` | `string \| null` | Id da arma preferida |
| `devotees` | `Record<string, unknown>` | `races` e `classes` devotas |
| `grantedPowers` | `string[]` | Ids dos poderes concedidos |
| `obligationsRestrictions` | `string \| null` | Obrigações e restrições |
| `rank` | `"maior" \| "menor"` | Posição no Panteão |
| `natureza` | `string \| null` | Natureza do deus menor |
| `statusDivino` | `number \| null` | Status divino (1–5) do deus menor |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `energiaPositiva() / energiaNegativa() / energiaQualquer()` | Por energia |
| `byEnergy(energy)` | Por energia |
| `maiores() / menores()` | Por posição no Panteão |

Para filtrar por livro: `Divindade.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `races()` | Ids das raças devotas |
| `classes()` | Ids das classes devotas |
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
const khalmyr = Divindade.find("khalmyr")!
khalmyr.grantedPowers
Poder.byDeity("khalmyr").all()
Divindade.menores().all()
```
