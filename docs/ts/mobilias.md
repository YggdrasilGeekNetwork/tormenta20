# Mobílias — TypeScript

Mobílias para cômodos de bases (Heróis de Arton).

```ts
import { Mobilia } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `effects` | `unknown[]` | Efeitos mecânicos |
| `preco` | `number \| null` | Preço em T$ |
| `comodoAlvo` | `string \| null` | Cômodo em que deve ser instalada |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |

Para filtrar por livro: `Mobilia.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Mobilia.find("banheira")?.comodoAlvo  // "suite"
```
