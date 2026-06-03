# Classes — TypeScript

```ts
import { Classe } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador único |
| `name` | `string` | Nome da classe |
| `initialHp` | `number` | PV inicial (nível 1) |
| `hpPerLevel` | `number` | PV por nível |
| `mpPerLevel` | `number` | PM por nível |
| `isConjurador` | `boolean` | `true` se a classe conjura magias |
| `spellcasting` | `Record<string,unknown> \| null` | Dados de conjuração, ou `null` |
| `mandatorySkills` | `unknown[]` | Perícias obrigatórias |
| `chooseSkillsAmount` | `number` | Quantidade de perícias a escolher |
| `availableSkills` | `unknown[]` | Pool de perícias para escolha |
| `weaponProficiencies` | `string[]` | Categorias de armas |
| `armorProficiencies` | `string[]` | Categorias de armaduras |
| `shieldProficiency` | `boolean` | Proficiência em escudos |
| `abilities` | `unknown[]` | Habilidades de classe por nível |
| `powers` | `unknown[]` | Poderes desbloqueáveis |
| `progression` | `unknown[]` | Tabela de progressão |

## Queries

```ts
Classe.all()
Classe.conjuradores().all()   // apenas classes com magia
Classe.find("guerreiro")
Classe.count()
```

## Exemplos

```ts
const guerreiro = Classe.find("guerreiro")!
guerreiro.initialHp          // 20
guerreiro.hpPerLevel         // 5
guerreiro.isConjurador       // false

// Classes conjuradoras com PM/nível
Classe.conjuradores().all().forEach(c => {
  console.log(`${c.name}: ${c.mpPerLevel} PM/nível`)
})

// Classes com proficiência em armadura pesada
Classe.all()
  .filter(c => c.armorProficiencies.includes("pesadas"))
  .forEach(c => console.log(c.name))

// Ordenar por PV inicial
Classe.all()
  .sort((a, b) => b.initialHp - a.initialHp)
  .forEach(c => console.log(`${c.name}: ${c.initialHp} PV`))
```
