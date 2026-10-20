# Poções — TypeScript

Poções, óleos e granadas, com faixas de rolagem para tesouro aleatório.

```ts
import { Pocao } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `subtipo` | `string` | `pocao`, `oleo` ou `granada` |
| `spellId` | `string` | Magia reproduzida |
| `pmCost` | `number` | Custo em PM do efeito |
| `categoria` | `string` | `menor`, `medio` ou `maior` |
| `preco` | `number` | Preço em T$ |
| `rollMin / rollMax` | `number \| null` | Faixa na tabela de tesouro |
| `aprimoramento` | `string \| null` | Aprimoramento aplicado |
| `description` | `string \| null` | Descrição |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `menores() / medias() / maiores()` | Por categoria |
| `pocoes() / oleos() / granadas()` | Por subtipo |

Para filtrar por livro: `Pocao.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Pocao.medias().all()
Magia.find(Pocao.find("alterar_tamanho")!.spellId)
```
