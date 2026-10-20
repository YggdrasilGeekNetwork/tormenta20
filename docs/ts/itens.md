# Itens — TypeScript

Itens gerais: aventura, alimentação, alquímicos, animais, aparatos, esotéricos, ferramentas, serviços, veículos e vestuário.

```ts
import { Item } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `category` | `string \| null` | Categoria |
| `price` | `number` | Preço em T$ (0 quando ausente) |
| `weight` | `number` | Espaços (0 quando ausente) |
| `description` | `string \| null` | Descrição |
| `effects` | `Record<string, unknown>` | Demais dados do item |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `byCategory(cat)` | Por categoria |

Para filtrar por livro: `Item.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` (tabela ainda não indexada: sempre `null`) |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Item.byCategory("alquimico").order("price").all()
Item.find("banho_quente")?.effects
```
