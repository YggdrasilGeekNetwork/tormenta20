# Livros

Livros cobertos pela biblioteca. Todo registro de conteúdo tem `livro_id` apontando para um deles.

Acesso: `Tormenta20.livros` (`Tormenta20::Models::Livro`)

> Livros: `t20_eja` (Tormenta20 — Edição Jogo do Ano), `herois_de_arton`, `deuses_de_arton`, `ameacas_de_arton`, `atlas_de_arton`.

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Identificador (ex.: `t20_eja`) |
| `nome` | String | Nome completo |
| `nome_curto` | String | Nome curto usado nas referências (ex.: `"T20 - EJA"`) |

## Scopes

Todos os scopes retornam `ActiveRecord::Relation` e podem ser encadeados com `where`, `order`, `limit` etc.

## Métodos de instância

| Método | Descrição |
|--------|-----------|
| `indice_remissivo_entries` | Entradas do índice remissivo do livro |
| `to_h` | Hash com os atributos |

## Exemplos

```ruby
Tormenta20.livros.pluck(:id, :nome_curto)
Tormenta20.livros.find("herois_de_arton").nome

# Qualquer modelo de conteúdo pode ser filtrado por livro
Tormenta20.poderes.do_livro("herois_de_arton").count
Tormenta20.classes.find("frade").livro.nome  # => "Deuses de Arton"
```
