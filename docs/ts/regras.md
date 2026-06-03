# Regras — TypeScript

```ts
import { Regra } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `data` | `Record<string,unknown>` | Dados estruturados (schema varia por entrada) |

## Queries

```ts
Regra.all()
Regra.find("combate")
Regra.count()
```
