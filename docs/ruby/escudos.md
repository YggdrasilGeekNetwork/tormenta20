# Escudos

Escudos. O Broquel tem `defense_bonus` 0: em vez do bônus normal, permite aparar ataques.

Acesso: `Tormenta20.escudos` (`Tormenta20::Models::Escudo`)

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador único |
| `name` | String | Nome |
| `price` | Float | Preço em T$ |
| `defense_bonus` | Integer | Bônus na Defesa |
| `armor_penalty` | Integer | Penalidade de armadura (negativa) |
| `weight` | Float | Espaços |
| `properties` | Array | Regras especiais |
| `description` | String | Descrição |
| `livro_id` | String | Livro de origem (`t20_eja`, `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`) |

## Scopes

| Scope | Descrição |
|-------|-----------|
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
Tormenta20.escudos.order(:defense_bonus).each do |e|
  puts "#{e.name}: +#{e.defense_bonus} Defesa, #{e.armor_penalty} de penalidade"
end

Tormenta20.escudos.find("broquel").properties
```
