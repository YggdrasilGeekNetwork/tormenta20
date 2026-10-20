# Armaduras — TypeScript

Armaduras leves e pesadas.

```ts
import { Armadura } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `category` | `ArmaduraCategory` | Categoria |
| `price` | `number` | Preço em T$ |
| `defenseBonus` | `number` | Bônus na Defesa |
| `armorPenalty` | `number` | Penalidade de armadura (negativa) |
| `weight` | `number` | Espaços |
| `properties` | `unknown[]` | Regras especiais |
| `description` | `string \| null` | Descrição |
| `isLeve / isPesada` | `boolean` | Atalhos |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `leves() / pesadas()` | Por categoria |
| `byCategory(cat)` | Por categoria |

Para filtrar por livro: `Armadura.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Armadura.leves().order("defense_bonus").all()
Armadura.find("armadura_de_quitina")?.armorPenalty  // -3
```
