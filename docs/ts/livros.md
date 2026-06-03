# Livros — TypeScript

```ts
import { Livro } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único (ex: `"t20_eja"`) |
| `name` | `string` | Nome completo |
| `nomeCurto` | `string` | Abreviação (ex: `"T20 - EJA"`) |

## Queries

```ts
Livro.all()
Livro.find("t20_eja")
Livro.count()
```
