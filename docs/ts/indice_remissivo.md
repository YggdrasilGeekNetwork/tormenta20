# Índice Remissivo — TypeScript

Entradas do índice remissivo, usadas para as referências de página (`book_reference`). Hoje só o livro básico está indexado.

```ts
import { IndiceRemissivo } from 'tormenta20'
```

## Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `id` | `string` | Identificador |
| `livroId` | `string` | Livro |
| `termo` | `string` | Termo indexado |
| `pagina` | `number` | Página |
| `tabela / registroId` | `string \| null` | Registro associado |
| `associado` | `boolean` | Tem registro associado |

## Queries

| Método estático | Descrição |
|-----------------|-----------|
| `all()` | Todos os registros |
| `find(id)` | Registro pelo id, ou `null` |
| `first() / last()` | Primeiro / último registro |
| `count()` | Total de registros |
| `query()` | `Query` encadeável (`where`, `order`, `limit`, `all`, `first`, `count`, `exists`) |
| `doLivro(livroId)` | Por livro |
| `paraTabela(tabela)` | Por tabela associada |
| `associados() / naoAssociados()` | Com / sem registro associado |
| `buscarTermo(q)` | Busca por termo |

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `toH()` | Objeto simples com os campos (snake_case) |

## Exemplos

```ts
IndiceRemissivo.buscarTermo("anão").all()
IndiceRemissivo.paraTabela("magias").count()
```
