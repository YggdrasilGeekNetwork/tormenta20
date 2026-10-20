# Tabelas — TypeScript

Tabelas de referência e de rolagem (aparência, itens inteligentes, encontros aleatórios por terreno e região…).

```ts
import { Tabela } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `headers` | `string[]` | Cabeçalhos |
| `rows` | `Record<string, unknown>[]` | Linhas |
| `dice` | `string \| null` | Dado de rolagem |
| `sorteavel` | `boolean` | Tem `dice` |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |

Para filtrar por livro: `Tabela.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `roll()` | Rola o dado e retorna a linha correspondente, ou `null` |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
const tabela = Tabela.find("encontros_aquatico")!
tabela.sorteavel  // true
tabela.roll()
```
