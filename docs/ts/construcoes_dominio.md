# Construções de Domínio — TypeScript

Construções de domínio (Heróis de Arton), com custo em Lingotes de Ouro (LO).

```ts
import { ConstrucaoDominio } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `categoria` | `ConstrucaoDominioCategoria` | Categoria |
| `custo` | `number \| null` | Custo em LO |
| `effects` | `unknown[]` | Efeitos mecânicos |
| `prerequisito` | `string \| null` | Pré-requisito |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `byCategoria(categoria)` | Por categoria |

Para filtrar por livro: `ConstrucaoDominio.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
ConstrucaoDominio.byCategoria("religiao").order("custo").all()
```
