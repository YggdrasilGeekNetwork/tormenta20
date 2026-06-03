# Divindades — TypeScript

```ts
import { Divindade, type DivindadeEnergy } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome |
| `title` | `string \| null` | Título/epíteto |
| `description` | `string \| null` | Descrição |
| `energy` | `DivindadeEnergy` | `"positiva"` \| `"negativa"` \| `"qualquer"` |
| `preferredWeapon` | `string \| null` | ID da arma preferida |
| `holySymbol` | `string \| null` | Símbolo sagrado |
| `grantedPowers` | `string[]` | IDs dos poderes concedidos |
| `beliefsObjectives` | `unknown[]` | Crenças e objetivos |
| `obligationsRestrictions` | `string \| null` | Obrigações/restrições |
| `devotees` | `Record<string,unknown>` | Devotos típicos |

## Queries

```ts
Divindade.all()
Divindade.energiaPositiva().all()
Divindade.energiaNegativa().all()
Divindade.energiaQualquer().all()
Divindade.byEnergy("positiva").all()

Divindade.find("khalmyr")
Divindade.count()
```

## Métodos de Instância

```ts
const d = Divindade.find("khalmyr")!

d.races()    // IDs de raças devotas   => ["humano", "anao"]
d.classes()  // IDs de classes devotas => ["paladino", "guerreiro"]
d.bookReference() // { livro, pagina, formatted } | null
```

## Exemplos

```ts
// Divindades que concedem um poder específico
Divindade.all()
  .filter(d => d.grantedPowers.includes("cura_pelas_maos"))
  .forEach(d => console.log(d.name))

// Adoradas por elfos
Divindade.all()
  .filter(d => d.races().includes("elfo"))
```
