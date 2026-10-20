# Livros — TypeScript

Livros cobertos pela biblioteca. Todo registro de conteúdo tem `livro_id` apontando para um deles.

```ts
import { Livro } from 'tormenta20'
```

> Livros: `t20_eja` (Tormenta20 — Edição Jogo do Ano), `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`.

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador |
| `name` | `string` | Nome completo |
| `nomeCurto` | `string` | Nome curto usado nas referências |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Livro.all().map((l) => l.nomeCurto)
Poder.query().where("livro_id = ?", "herois_de_arton").count()
```
