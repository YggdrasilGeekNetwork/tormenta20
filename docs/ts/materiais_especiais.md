# Materiais Especiais — TypeScript

```ts
import { MaterialEspecial } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `applicableTo` | `unknown[]` | Tipos de equipamento aplicáveis |
| `priceModifier` | `Record<string,unknown>` | Modificador de preço |
| `effects` | `Record<string,unknown>` | Efeitos mecânicos |

## Queries

```ts
MaterialEspecial.all()
MaterialEspecial.find("adamante")
MaterialEspecial.count()
```
