# Armaduras — TypeScript

```ts
import { Armadura, type ArmaduraCategory } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `category` | `ArmaduraCategory` | `"leve"` \| `"pesada"` |
| `defenseBonus` | `number` | Bônus de Defesa |
| `armorPenalty` | `number` | Penalidade em perícias |
| `price` | `number` | Preço em tibares |
| `weight` | `number` | Peso em espaços |
| `properties` | `unknown[]` | Propriedades especiais |
| `description` | `string \| null` | Descrição |
| `isLeve` | `boolean` | `true` se é armadura leve |
| `isPesada` | `boolean` | `true` se é armadura pesada |

## Queries

```ts
Armadura.all()
Armadura.leves().all()
Armadura.pesadas().all()
Armadura.byCategory("leve").all()

Armadura.find("couro")
Armadura.count()
```

## Exemplos

```ts
// Ordenar por bônus de defesa
Armadura.all()
  .sort((a, b) => b.defenseBonus - a.defenseBonus)
  .forEach(a => console.log(`${a.name}: +${a.defenseBonus}`))

// Armaduras sem penalidade
Armadura.all().filter(a => a.armorPenalty === 0)
```
