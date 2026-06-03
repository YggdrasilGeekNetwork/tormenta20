# Índice Remissivo — TypeScript

```ts
import { IndiceRemissivo } from 'tormenta20'
```

## Atributos

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Chave primária |
| `livroId` | `string` | FK para `Livro` |
| `termo` | `string` | Termo como aparece no índice |
| `pagina` | `number` | Número da página |
| `tabela` | `string \| null` | Tabela do registro vinculado |
| `registroId` | `string \| null` | ID do registro vinculado |
| `associado` | `boolean` | `true` se tem registro vinculado |

## Queries

```ts
IndiceRemissivo.all()
IndiceRemissivo.doLivro("t20_eja").all()
IndiceRemissivo.paraTabela("classes").all()
IndiceRemissivo.associados().all()
IndiceRemissivo.naoAssociados().all()
IndiceRemissivo.buscarTermo("espada").all()
IndiceRemissivo.count()

// combinado via Query builder
IndiceRemissivo.query()
  .where("livro_id = ?", "t20_eja")
  .where("tabela = ?", "classes")
  .order("pagina")
  .all()
```

## BookReference via modelos

Todos os modelos expõem `bookReference()` que consulta este índice internamente:

```ts
import { Classe, Magia, Raca } from 'tormenta20'

Classe.find("guerreiro")?.bookReference()
// => { livro: "Tormenta 20 - Edição Jogo do Ano", pagina: 64, formatted: "T20 - EJA, p. 64" }

Magia.find("bola_de_fogo")?.bookReference()
// => { ..., pagina: 80, formatted: "T20 - EJA, p. 80" }

Raca.find("elfo")?.bookReference()
// => null  (se não indexado)
```

## Exemplos

```ts
// Páginas de todas as classes indexadas
IndiceRemissivo.query()
  .where("tabela = ?", "classes")
  .order("pagina")
  .all()
  .forEach(e => console.log(`${e.registroId}: p. ${e.pagina}`))

// Termos gerais (sem registro vinculado) sobre combate
IndiceRemissivo.naoAssociados()
  .where("termo LIKE ?", "%combate%")
  .all()
  .forEach(e => console.log(`${e.termo}: p. ${e.pagina}`))
```
