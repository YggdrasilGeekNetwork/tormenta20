# Itens Litúrgicos — TypeScript

Itens litúrgicos de Deuses de Arton, ligados a uma ou mais divindades.

```ts
import { ItemLiturgico } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `deities` | `string[]` | Ids das divindades associadas |
| `subtipo` | `ItemLiturgicoSubtipo \| null` | Subtipo |
| `baseItem` | `string \| null` | Item base |
| `classificacao` | `string \| null` | Classificação no livro |
| `preco` | `number \| null` | Preço em T$ |
| `description` | `string \| null` | Descrição |
| `effects` | `unknown[]` | Efeitos mecânicos |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `byDeity(deityId)` | Por divindade |
| `bySubtipo(subtipo)` | Por subtipo |

Para filtrar por livro: `ItemLiturgico.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
ItemLiturgico.byDeity("lin_wu").all()
```
