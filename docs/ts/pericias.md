# Perícias — TypeScript

As 29 perícias do livro básico.

```ts
import { Pericia } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `atributo` | `PericiaAtributo` | Atributo-chave |
| `trainedOnly / armorPenalty / resistanceSkill` | `boolean` | Flags |
| `description` | `string \| null` | Descrição |
| `uses` | `unknown[]` | Usos da perícia |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `byAtributo(attr)` | Por atributo |
| `trainedOnlySkills()` | Somente treinadas |
| `withArmorPenalty()` | Com penalidade de armadura |
| `resistanceSkills()` | Testes de resistência |

Para filtrar por livro: `Pericia.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Pericia.byAtributo("DES").all()
Pericia.find("acrobacia")?.armorPenalty  // true
```
