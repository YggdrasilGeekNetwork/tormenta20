# Itens

Itens gerais: aventura, alimentação, alquímicos, animais, aparatos, esotéricos, ferramentas, serviços, veículos e vestuário.

Acesso: `Tormenta20.itens` (`Tormenta20::Models::Item`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `category` | String | `alimentacao`, `alquimico`, `animal`, `aparato`, `aventura`, `esoterico`, `ferramenta`, `servico`, `veiculo`, `vestuario` |
| `price` | Float | Preço em T$, ou `nil` |
| `weight` | Float | Espaços, ou `nil` |
| `description` | String | Descrição |
| `effects` | Hash | Demais dados do item (efeito, duração, etc.) |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
| `by_category(c)` | Por categoria |
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
Tormenta20.itens.by_category("alquimico").order(:price)
Tormenta20.itens.group(:category).count
Tormenta20.itens.find("banho_quente").effects
```
