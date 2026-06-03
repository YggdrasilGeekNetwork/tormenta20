# Raças — TypeScript

```ts
import { Raca, type RacaSize, type RacaVision } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string` | Descrição |
| `size` | `RacaSize` | `"minúsculo"` \| `"pequeno"` \| `"médio"` \| `"grande"` |
| `movement` | `number` | Deslocamento em metros |
| `vision` | `RacaVision` | Tipo de visão |
| `visionRange` | `number \| null` | Alcance da visão especial (metros) |
| `attributeBonuses` | `Record<string,number>` | Bônus de atributos (ex: `{ CON: 2 }`) |
| `skillBonuses` | `unknown[]` | Bônus em perícias |
| `racialAbilities` | `string[]` | IDs de habilidades fixas |
| `chosenAbilitiesAmount` | `number` | Quantidade a escolher |
| `availableChosenAbilities` | `unknown[]` | Pool de habilidades |
| `isPequeno` | `boolean` | |
| `isMinusculo` | `boolean` | |
| `isGrande` | `boolean` | |
| `hasVisaoNoEscuro` | `boolean` | |

## Queries

```ts
Raca.all()
Raca.find("anao")
Raca.count()

// filtros via Query builder
Raca.query().where("vision = ?", "visao_no_escuro").all()
Raca.query().where("size = ?", "médio").all()
```

## Métodos de Instância

```ts
const anao = Raca.find("anao")!

anao.attributeBonusFor("CON")   // 2
anao.attributeBonusFor("FOR")   // 0
anao.hasVisaoNoEscuro           // true
anao.bookReference()            // { livro, pagina, formatted } | null
```

## Exemplos

```ts
// Raças com visão no escuro
Raca.all()
  .filter(r => r.hasVisaoNoEscuro)
  .forEach(r => console.log(`${r.name}: ${r.visionRange}m`))

// Bônus de CON por raça
Raca.all()
  .filter(r => r.attributeBonusFor("CON") > 0)
  .forEach(r => console.log(`${r.name}: +${r.attributeBonusFor("CON")} CON`))
```
