# Materiais Especiais — TypeScript

Materiais especiais (adamante, mitral, aço-rubi…), do livro básico e de Ameaças de Arton.

```ts
import { MaterialEspecial } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `applicableTo` | `unknown[]` | Reservado, sempre `[]` |
| `priceModifier` | `Record<string, unknown>` | Preço adicional por tipo de item |
| `effects` | `Record<string, unknown>` | Efeitos mecânicos |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |

Para filtrar por livro: `MaterialEspecial.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
MaterialEspecial.find("adamante")?.priceModifier.arma  // 3000
MaterialEspecial.all().filter((m) => "arma" in m.priceModifier)
```
