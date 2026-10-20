# Distinções — TypeScript

Distinções de Heróis de Arton e Deuses de Arton. Os poderes de cada distinção ficam em `Poder` com `type: "poder_distincao"`.

```ts
import { Distincao } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `admissao` | `string \| null` | Requisitos de admissão |
| `marcaNome` | `string \| null` | Nome da Marca da Distinção |
| `marcaDescricao` | `string \| null` | Efeito da Marca |
| `nivelMinimo` | `number` | Nível mínimo (padrão 5) |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |

Para filtrar por livro: `Distincao.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
const amazona = Distincao.find("amazona")!
amazona.marcaNome
Poder.byDistincao(amazona.id).all()
```
