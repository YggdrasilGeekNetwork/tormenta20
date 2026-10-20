# Índice Remissivo

Entradas do índice remissivo, usadas para as referências de página (`book_reference`). Hoje só o livro básico está indexado.

Acesso: `Tormenta20.indice_remissivo` (`Tormenta20::Models::IndiceRemissivo`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | Integer | Identificador |
| `livro_id` | String | Livro |
| `termo` | String | Termo indexado |
| `pagina` | Integer | Página |
| `tabela` | String | Tabela do registro associado, ou `nil` |
| `registro_id` | String | Id do registro associado, ou `nil` |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `do_livro(livro_id)` | Por livro |
| `para_tabela(tabela)` | Por tabela associada |
| `associados / nao_associados` | Com / sem registro associado |
| `buscar_termo(q)` | Busca por termo (LIKE) |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `associado?` | Tem registro associado |
| `livro` | Registro `Livro` |
| `to_h` | Hash com os atributos |

## Exemplos

```ruby
Tormenta20.indice_remissivo.buscar_termo("anão")
Tormenta20.indice_remissivo.para_tabela("magias").count
```
