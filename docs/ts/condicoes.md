# Condições — TypeScript

Condições de status do livro básico.

```ts
import { Condicao } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `effects` | `unknown[]` | Efeitos mecânicos |
| `conditionType` | `CondicaoType \| null` | Tipo |
| `escalatesTo` | `string \| null` | Id da condição mais grave |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `byType(type)` | Por tipo |
| `medo() / mental() / metabolismo() / movimento()` | Atalhos por tipo |

Para filtrar por livro: `Condicao.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Condicao.find("fatigado")?.escalatesTo  // "exausto"
Condicao.medo().all()
```
