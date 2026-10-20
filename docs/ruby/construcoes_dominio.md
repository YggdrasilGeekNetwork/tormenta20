# Construções de Domínio

Construções de domínio (Heróis de Arton), com custo em Lingotes de Ouro (LO).

Acesso: `Tormenta20.construcoes_dominio` (`Tormenta20::Models::ConstrucaoDominio`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `description` | String | Descrição |
| `categoria` | String | `nobreza`, `guerra`, `enganacao`, `religiao` ou `misticismo` |
| `custo` | Integer | Custo em LO |
| `effects` | Array | Efeitos mecânicos |
| `prerequisito` | String | Pré-requisito, ou `nil` |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_categoria(categoria)` | Por categoria |
| `do_livro(livro_id)` | Registros de um livro |

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `book_reference` | Referência formatada (`"T20 - EJA, p. 20"`) ou `nil` |
| `page / book / full_book` | Página, nome curto e nome completo do livro, ou `nil` |
| `livro` | Registro `Livro` associado |
| `to_h` | Hash com os atributos |

O índice remissivo ainda não liga registros desta tabela, então `book_reference` retorna `nil`.

## Exemplos

```ruby
Tormenta20.construcoes_dominio.by_categoria("religiao").order(:custo)
Tormenta20.construcoes_dominio.find("abadia").custo  # => 12
```
