# Condições — TypeScript

```ts
import { Condicao, type CondicaoType } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `effects` | `unknown[]` | Efeitos mecânicos |
| `conditionType` | `CondicaoType \| null` | Categoria |
| `escalatesTo` | `string \| null` | ID da condição seguinte na cadeia |

## Tipos (`CondicaoType`)

`"medo"` · `"mental"` · `"metabolismo"` · `"movimento"` · `"veneno"` · `"sentidos"` · `"cansaco"` · `"metamorfose"`

## Queries

```ts
Condicao.all()
Condicao.medo().all()
Condicao.mental().all()
Condicao.metabolismo().all()
Condicao.movimento().all()
Condicao.byType("medo").all()

Condicao.find("abalado")
Condicao.count()
```

## Exemplos

```ts
// Cadeia de escalonamento de medo
Condicao.medo().all().forEach(c => {
  const next = c.escalatesTo ?? "—"
  console.log(`${c.name} → ${next}`)
})
// abalado → apavorado → ...
```
