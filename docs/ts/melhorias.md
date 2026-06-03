# Melhorias — TypeScript

```ts
import { Melhoria } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `applicableTo` | `unknown[]` | Tipos de equipamento aplicáveis |
| `price` | `number` | Preço em tibares |
| `effects` | `Record<string,unknown>` | Efeitos mecânicos |

## Queries

```ts
Melhoria.all()
Melhoria.find("resistente")
Melhoria.count()
```
