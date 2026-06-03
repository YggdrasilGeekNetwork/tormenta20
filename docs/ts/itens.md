# Itens — TypeScript

```ts
import { Item } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `category` | `string \| null` | Categoria (ex: `"ferramenta"`, `"alquimico"`) |
| `price` | `number` | Preço em tibares |
| `weight` | `number` | Peso em espaços |
| `description` | `string \| null` | Descrição |
| `effects` | `Record<string,unknown>` | Efeitos mecânicos |

## Queries

```ts
Item.all()
Item.byCategory("alquimico").all()
Item.find("corda")
Item.count()
```
