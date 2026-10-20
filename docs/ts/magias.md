# Magias — TypeScript

Magias arcanas, divinas e universais do livro básico e dos suplementos.

```ts
import { Magia } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `type` | `MagiaType` | `arcana`, `divina` ou `universal` |
| `circle` | `string` | Círculo, como string |
| `school` | `MagiaSchool` | Escola |
| `execution / executionDetails` | `string` | Tempo de execução |
| `range` | `string` | Alcance |
| `duration / durationDetails` | `string` | Duração |
| `counterspell` | `string \| null` | Id da contramágica |
| `description` | `string` | Descrição |
| `enhancements` | `unknown[]` | Aprimoramentos |
| `effects` | `unknown[]` | Efeitos mecânicos tipados |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `arcanas() / divinas() / universais()` | Por tradição |
| `byType(type)` | Por tradição |
| `byCircle(circle) / doCirculo(circle)` | Por círculo (string) |
| `bySchool(school) / daEscola(school)` | Por escola |

Para filtrar por livro: `Magia.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `targetInfo()` | `{ amount, upTo, type }` ou `null` |
| `resistenceInfo()` | `{ effect, skill }` ou `null` |
| `extraCostsInfo()` | Custos extras (`material_component`, `material_cost`, `pm_debuff`, `pm_sacrifice`) ou `null` |
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` (tabela ainda não indexada: sempre `null`) |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Magia.arcanas().where("circle = ?", "3").all()
Magia.bySchool("evoc").order("name").all()

const bola = Magia.find("bola_de_fogo")
bola?.resistenceInfo()?.skill  // "reflexos"
```
