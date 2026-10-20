# Ameaças — TypeScript

Bestiário: as criaturas do livro básico, de Deuses de Arton e de Ameaças de Arton (incluindo montarias, mascotes e familiares).

```ts
import { Ameaca } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `nd` | `number` | Nível de Desafio |
| `tipo / subtipo` | `string \| null` | Tipo e subtipo |
| `tamanho / grupo` | `string` | Tamanho e grupo temático |
| `pv / defesa / pm` | `number \| null` | PV, Defesa e PM |
| `forca / des / con / int / sab / car` | `number \| null` | Atributos (`for` vira `forca`) |
| `iniciativa / percepcao` | `number \| null` | Bônus |
| `deslocamento / visao` | `string \| null` | JSON em texto |
| `salvaguardas` | `Record<string, number>` | `fort`, `ref`, `von` |
| `ataques / poderesEspeciais` | `unknown[]` | Ataques e habilidades especiais |
| `imunidades / vulnerabilidades` | `string[]` | Imunidades e vulnerabilidades |
| `resistencias / pericias` | `Record<string, number>` | Resistências e perícias |
| `reducaoDeDano / curaAcelerada` | `number \| string \| null` | Ex.: `10` ou `"10/luz"` |
| `resistenciaAMagia` | `number \| null` | Resistência a magia |
| `equipamento` | `string[]` | Equipamento |
| `tesouro / description` | `string \| null` | Tesouro e descrição |
| `familiar` | `string \| null` | Benefício como familiar |
| `parceiro` | `Record<string, unknown> \| null` | Benefícios como parceiro |
| `atributos` | `{ for, des, con, int, sab, car }` | Atributos agrupados |
| `livroId` | `string` | Livro de origem (`t20_eja`, `herois_de_arton`, …) |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `byGrupo(grupo)` | Por grupo |
| `byNd(nd) / upToNd(nd)` | ND exato / até um ND |
| `avatares()` | Avatares |

Para filtrar por livro: `Ameaca.query().where("livro_id = ?", "herois_de_arton")`.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
Ameaca.upToNd(2).where("grupo = ?", "ermos").order("nd").all()
Ameaca.find("avatar_de_megalokk")?.curaAcelerada  // "100/kaiju"
JSON.parse(Ameaca.find("dragao_rei")!.deslocamento!)
```
