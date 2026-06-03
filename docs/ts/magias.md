# Magias — TypeScript

```ts
import { Magia, type MagiaType, type MagiaSchool } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome da magia |
| `type` | `MagiaType` | `"arcana"` \| `"divina"` \| `"universal"` |
| `circle` | `string` | Círculo (`"1"` – `"5"`) |
| `school` | `MagiaSchool` | Escola de magia |
| `execution` | `string` | Tempo de execução |
| `executionDetails` | `string \| null` | Detalhes da execução |
| `range` | `string` | Alcance |
| `duration` | `string` | Duração |
| `durationDetails` | `string \| null` | Detalhes da duração |
| `description` | `string` | Descrição completa |
| `counterspell` | `string \| null` | ID da contramagia |
| `enhancements` | `unknown[]` | Aprimoramentos disponíveis |
| `effects` | `unknown[]` | Efeitos mecânicos |

## Queries

```ts
Magia.all()
Magia.arcanas().all()
Magia.divinas().all()
Magia.universais().all()
Magia.byType("arcana").all()
Magia.byCircle("3").all()
Magia.doCirculo("3").all()             // alias em português
Magia.bySchool("evoc").all()
Magia.daEscola("evoc").all()           // alias em português

// combinando filtros
Magia.query()
  .where("circle = ?", "3")
  .where("type = ?", "arcana")
  .order("name")
  .all()

Magia.find("bola_de_fogo")
Magia.count()
```

## Métodos de Instância

```ts
const magia = Magia.find("bola_de_fogo")!

magia.targetInfo()
// => { amount: 1, upTo: false, type: "criatura" } | null

magia.resistenceInfo()
// => { effect: "reduz", skill: "Reflexos" } | null

magia.extraCostsInfo()
// => { material_component: "enxofre", pm_sacrifice: 2, ... } | null

magia.bookReference()
// => { livro: "...", pagina: 80, formatted: "T20 - EJA, p. 80" } | null
```

## Exemplos

```ts
// Magias arcanas do 3º círculo
Magia.arcanas().all()
  .filter(m => m.circle === "3")
  .forEach(m => console.log(m.name))

// Usando o Query builder
Magia.query()
  .where("type = ?", "arcana")
  .where("circle = ?", "3")
  .order("name")
  .all()
  .forEach(m => console.log(`${m.name} — ${m.school}`))

// Magias com componentes materiais
Magia.all()
  .filter(m => m.extraCostsInfo() !== null)
  .forEach(m => console.log(m.name))
```
