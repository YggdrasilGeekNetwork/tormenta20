# Origens — TypeScript

Origens de personagem: as do livro básico e de Heróis de Arton, mais as 66 origens regionais do Atlas de Arton (a região aparece no início da descrição).

```ts
import { Origem } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string` | Descrição |
| `items` | `unknown[]` | Itens iniciais |
| `benefits` | `Record<string, unknown>` | `skills` e `powers` oferecidos |
| `uniquePower` | `string \| null` | Id do poder único |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `withUniquePower()` | Origens com poder único |

Para filtrar por livro: `Origem.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `skills()` | Ids de perícias oferecidas |
| `powers()` | Ids de poderes oferecidos |
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
const acolito = Origem.find("acolito")!
acolito.skills()
Poder.find(acolito.uniquePower!)
Origem.query().where("livro_id = ?", "atlas_de_arton").count()
```
