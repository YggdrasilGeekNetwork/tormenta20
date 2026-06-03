# Escudos — TypeScript

```ts
import { Escudo } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `defenseBonus` | `number` | Bônus de Defesa |
| `armorPenalty` | `number` | Penalidade em perícias |
| `price` | `number` | Preço em tibares |
| `weight` | `number` | Peso em espaços |
| `properties` | `unknown[]` | Propriedades especiais |
| `description` | `string \| null` | Descrição |

## Queries

```ts
Escudo.all()
Escudo.find("escudo_leve")
Escudo.count()
```
