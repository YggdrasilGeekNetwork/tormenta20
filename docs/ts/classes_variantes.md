# Classes Variantes — TypeScript

Variantes de classe de Heróis de Arton (ex.: Alquimista, variante do Inventor). Cada variante descreve as diferenças por nível em relação à classe base.

```ts
import { ClasseVariante } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `baseClassId` | `string` | Id da classe base |
| `description` | `string \| null` | Descrição |
| `diffs` | `unknown[]` | Diferenças por nível: `{ nivel, remove, adiciona }` |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `byBase(classId)` | Variantes de uma classe base |

Para filtrar por livro: `ClasseVariante.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
const alquimista = ClasseVariante.find("alquimista")!
Classe.find(alquimista.baseClassId)?.name  // "Inventor"
ClasseVariante.byBase("bucaneiro").all()
```
