# Armas — TypeScript

```ts
import { Arma, type ArmaCategory, type DamageType } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `category` | `ArmaCategory` | `"simples"` \| `"marciais"` \| `"exoticas"` \| `"fogo"` |
| `damage` | `string` | Dano (ex: `"1d8"`) |
| `damageType` | `DamageType` | `"corte"` \| `"perfuracao"` \| `"impacto"` |
| `critical` | `string` | Ameaça/multiplicador (ex: `"19/x2"`) |
| `range` | `string \| null` | Incremento de alcance, ou `null` para corpo a corpo |
| `price` | `number` | Preço em tibares |
| `weight` | `number` | Peso em espaços |
| `properties` | `unknown[]` | Propriedades especiais |
| `description` | `string \| null` | Descrição |
| `isRanged` | `boolean` | `true` se tem incremento de alcance |
| `isMelee` | `boolean` | `true` se é corpo a corpo |

## Queries

```ts
Arma.all()
Arma.simples().all()
Arma.marciais().all()
Arma.exoticas().all()
Arma.fogo().all()
Arma.byCategory("marciais").all()
Arma.byDamageType("corte").all()
Arma.ranged().all()
Arma.melee().all()

Arma.find("espada_longa")
Arma.count()
```

## Exemplos

```ts
const espada = Arma.find("espada_longa")!
espada.damage      // "1d8"
espada.critical    // "19/x2"
espada.isRanged    // false

// Armas de distância
Arma.ranged().all().forEach(a => {
  console.log(`${a.name}: alcance ${a.range}`)
})
```
