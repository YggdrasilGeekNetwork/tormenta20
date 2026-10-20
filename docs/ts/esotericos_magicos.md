# Esotéricos Mágicos — TypeScript

Esotéricos mágicos de Heróis de Arton (cajados, varinhas…).

```ts
import { EsotericoMagico } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `categoria` | `string` | `menor`, `medio` ou `maior` |
| `preco` | `number` | Preço em T$ |
| `rollMin / rollMax` | `number \| null` | Faixa na tabela de tesouro |
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
| `menores() / medios() / maiores()` | Por categoria |

Para filtrar por livro: `EsotericoMagico.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
EsotericoMagico.maiores().order("preco").all()
EsotericoMagico.find("cajado_das_mares")?.effects
```
