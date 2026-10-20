# Poderes — TypeScript

Todos os poderes e habilidades: de classe, raça, origem, concedidos, da Tormenta, gerais (combate, destino, magia), de raça, de grupo e de distinção.

```ts
import { Poder } from 'tormenta20'
```

> Os poderes gerais são classificados pelo subtipo (`poder_combate`, `poder_destino`, `poder_magia`, `poder_de_raca`, `poder_de_grupo`). Nenhum registro usa `poder_geral`, então `poderes_gerais` retorna vazio.

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `type` | `PoderType` | Tipo do poder |
| `description` | `string \| null` | Descrição |
| `effects` | `unknown[]` | Efeitos mecânicos (pode vir como objeto ou `"ver_texto"`) |
| `costs` | `unknown[]` | Custos de ativação |
| `prerequisites` | `unknown[]` | Pré-requisitos |
| `originId / classId / distincaoId` | `string \| null` | Dono do poder |
| `deities` | `string[]` | Divindades que concedem o poder |
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
| `poderesClasse() / habilidadesDeRaca() / habilidadesUnicas()` | Classe, raça, origem |
| `poderesConcedidos() / poderesTormenta()` | Concedidos e da Tormenta |
| `poderesCombate() / poderesDestino() / poderesMagia()` | Gerais por subtipo |
| `poderesDeRaca() / poderesDeGrupo() / poderesDistincao()` | Heróis/Deuses de Arton |
| `byClass(id) / byOrigin(id) / byDistincao(id)` | Por dono |
| `byDeity(id)` | Concedidos por uma divindade |

Para filtrar por livro: `Poder.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `bookReference()` | `{ livro, pagina, formatted }` ou `null` (tabela ainda não indexada: sempre `null`) |
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Poder.byClass("arcanista").count()
Poder.poderesCombate().order("name").all()
Poder.byDistincao("amazona").all()
Poder.find("barreira_mistica")?.costs  // [{ value: 1, type: "PM" }]
```
