# Escudos — TypeScript

Escudos. O Broquel tem `defense_bonus` 0: em vez do bônus normal, permite aparar ataques.

```ts
import { Escudo } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `price` | `number` | Preço em T$ |
| `defenseBonus` | `number` | Bônus na Defesa |
| `armorPenalty` | `number` | Penalidade de armadura (negativa) |
| `weight` | `number` | Espaços |
| `properties` | `unknown[]` | Regras especiais |
| `description` | `string \| null` | Descrição |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |

Para filtrar por livro: `Escudo.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` (tabela ainda não indexada: sempre `null`) |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Escudo.query().order("defense_bonus").all()
Escudo.find("escudo_torre")?.armorPenalty  // -4
```
