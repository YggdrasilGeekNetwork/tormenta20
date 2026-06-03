# Origens — TypeScript

```ts
import { Origem } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string` | Descrição |
| `items` | `unknown[]` | Itens iniciais |
| `benefits` | `Record<string,unknown>` | Benefícios (skills, powers) |
| `uniquePower` | `string \| null` | ID do poder único, ou `null` |

## Queries

```ts
Origem.all()
Origem.withUniquePower().all()
Origem.find("soldado")
Origem.count()
```

## Métodos de Instância

```ts
const o = Origem.find("soldado")!

o.skills()   // IDs de perícias treinadas  => ["Luta", "Fortitude"]
o.powers()   // IDs de poderes concedidos  => ["proficiencia"]
o.bookReference() // { livro, pagina, formatted } | null
```

## Exemplos

```ts
// Origens que treinam Furtividade
Origem.all()
  .filter(o => o.skills().includes("Furtividade"))
  .forEach(o => console.log(o.name))
```
