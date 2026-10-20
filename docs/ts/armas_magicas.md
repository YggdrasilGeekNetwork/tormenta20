# Armas Mágicas Específicas — TypeScript

Armas mágicas específicas (itens com nome próprio).

```ts
import { ArmaMagicaEspecifica } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `baseWeapon` | `string \| null` | Id da arma base |
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
| `byBase(weaponId)` | Por arma base |

Para filtrar por livro: `ArmaMagicaEspecifica.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
ArmaMagicaEspecifica.byBase("adaga").all()
```
