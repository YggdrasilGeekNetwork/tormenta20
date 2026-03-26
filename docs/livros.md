# Livros

Acesso: `Tormenta20.livros`

Registra os livros cujos índices remissivos estão disponíveis na gem. Usado internamente pelo concern `BookReferenceable` para resolver referências de página em todos os modelos.

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | String | Slug do livro (ex: `"t20_eja"`) |
| `nome` | String | Nome completo (ex: `"Tormenta 20 - Edição Jogo do Ano"`) |
| `nome_curto` | String | Abreviação (ex: `"T20 - EJA"`) |

## Associações

```ruby
livro = Tormenta20.livros.find("t20_eja")

livro.indice_remissivo_entries        # Todas as entradas do índice deste livro
livro.indice_remissivo_entries.count  # => 1098
```

## Exemplos

```ruby
# Listar livros disponíveis
Tormenta20.livros.all.each do |l|
  puts "#{l.id}: #{l.nome} (#{l.nome_curto})"
end

# Acessar entradas do índice de um livro
t20 = Tormenta20.livros.find("t20_eja")
t20.indice_remissivo_entries.para_tabela("classes").each do |e|
  puts "#{e.termo}: p. #{e.pagina}"
end
```

## Livros Disponíveis

| ID | Nome | Abreviação | Entradas |
|----|------|------------|----------|
| `t20_eja` | Tormenta 20 - Edição Jogo do Ano | T20 - EJA | 1098+ |
