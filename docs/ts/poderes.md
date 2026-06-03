# Poderes — TypeScript

```ts
import { Poder, type PoderType } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `type` | `PoderType` | Tipo do poder |
| `description` | `string \| null` | Descrição |
| `effects` | `unknown[]` | Efeitos (formato varia por tipo) |
| `costs` | `unknown[]` | Custos de ativação |
| `prerequisites` | `unknown[]` | Pré-requisitos |
| `originId` | `string \| null` | ID da origem associada |
| `classId` | `string \| null` | ID da classe associada |
| `deities` | `string[]` | IDs das divindades que o concedem |

## Tipos (`PoderType`)

| Valor | Descrição |
|-------|-----------|
| `"habilidade_unica_origem"` | Habilidade única de origem |
| `"poder_concedido"` | Poder concedido por divindade |
| `"poder_tormenta"` | Poder da Tormenta |
| `"poder_classe"` | Poder de classe |
| `"habilidade_de_raca"` | Habilidade racial |
| `"poder_geral"` | Poder geral |
| `"poder_combate"` | Poder de combate |
| `"poder_destino"` | Poder de destino |
| `"poder_magia"` | Poder de magia |

## Queries

```ts
Poder.all()
Poder.poderesCombate().all()
Poder.poderesGerais().all()
Poder.poderesDestino().all()
Poder.poderesMagia().all()
Poder.poderesConcedidos().all()
Poder.poderesTormenta().all()
Poder.poderesClasse().all()
Poder.habilidadesUnicas().all()
Poder.habilidadesDeRaca().all()
Poder.byType("poder_combate").all()
Poder.byOrigin("soldado").all()
Poder.byDeity("khalmyr").all()
Poder.byClass("guerreiro").all()

Poder.find("ataque_poderoso")
Poder.count()
```

## Métodos de Instância

```ts
const poder = Poder.find("ataque_poderoso")!

poder.bookReference()
// => { livro: "...", pagina: 112, formatted: "T20 - EJA, p. 112" } | null
```

## Exemplos

```ts
// Poderes concedidos por Khalmyr
Poder.byDeity("khalmyr").all()
  .forEach(p => console.log(p.name))

// Habilidades únicas da origem Nobre
Poder.byOrigin("nobre").all()

// Buscar por nome
Poder.query()
  .where("name LIKE ?", "%Fúria%")
  .all()
```
