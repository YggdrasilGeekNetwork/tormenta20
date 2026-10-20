# Armas — TypeScript

Armas simples, marciais, exóticas e de fogo.

```ts
import { Arma } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `category` | `ArmaCategory` | Categoria |
| `price` | `number` | Preço em T$ |
| `damage` | `string` | Dano |
| `damageType` | `DamageType` | Tipo de dano |
| `critical` | `string` | Crítico |
| `range` | `string \| null` | Alcance |
| `weight` | `number` | Espaços |
| `properties` | `unknown[]` | Habilidades da arma e regras especiais |
| `description` | `string \| null` | Descrição |
| `isRanged / isMelee` | `boolean` | Atalhos |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `simples() / marciais() / exoticas() / fogo()` | Por categoria |
| `byCategory(cat)` | Por categoria |
| `byDamageType(type)` | Por tipo de dano |
| `melee() / ranged()` | Corpo a corpo / à distância |

Para filtrar por livro: `Arma.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Arma.marciais().where("range IS NULL").all()
Arma.find("chicote")?.properties
```
