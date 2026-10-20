# Encantamentos — TypeScript

Encantamentos de itens mágicos (armas, armaduras/escudos, esotéricos, acessórios), incluindo maldições.

```ts
import { Encantamento } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `description` | `string \| null` | Descrição |
| `categoria` | `EncantamentoCategoria` | Categoria |
| `escudoOnly / contaComoDois / maldicao` | `boolean` | Flags |
| `prerequisitos` | `unknown[]` | Pré-requisitos |
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
| `armas()` | Encantamentos de arma |
| `armadurasEscudos()` | Encantamentos de armadura/escudo |
| `escudoOnly()` | Só para escudos |
| `maldicoes() / naoMaldicoes()` | Maldições / normais |

Para filtrar por livro: `Encantamento.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Encantamento.armas().all()
Encantamento.maldicoes().count()
```
