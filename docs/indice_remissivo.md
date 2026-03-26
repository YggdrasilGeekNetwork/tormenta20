# Índice Remissivo

Acesso: `Tormenta20.indice_remissivo`

Armazena as entradas do índice remissivo de cada livro. Quando uma entrada possui `tabela` e `registro_id` preenchidos, ela fica vinculada a um registro concreto de outro model — o que permite que qualquer model retorne sua referência de livro e página via `BookReferenceable`.

## Atributos

| Atributo | Tipo | Descrição |
|----------|------|-----------|
| `id` | Integer | Chave primária (autoincremento) |
| `livro_id` | String | ID do livro (FK para `livros`) |
| `termo` | String | Termo como aparece no índice |
| `pagina` | Integer | Número da página |
| `tabela` | String / nil | Nome da tabela do registro vinculado |
| `registro_id` | String / nil | ID do registro vinculado |

## Scopes (Filtros)

```ruby
# Entradas de um livro específico
Tormenta20.indice_remissivo.do_livro("t20_eja")

# Entradas de uma tabela específica
Tormenta20.indice_remissivo.para_tabela("classes")
Tormenta20.indice_remissivo.para_tabela("poderes")

# Entradas vinculadas a registros concretos
Tormenta20.indice_remissivo.associados

# Entradas sem vínculo a registro (termos gerais)
Tormenta20.indice_remissivo.nao_associados

# Busca por termo (LIKE)
Tormenta20.indice_remissivo.buscar_termo("Fúria")
Tormenta20.indice_remissivo.buscar_termo("magia")
```

## Métodos de Instância

```ruby
entrada = Tormenta20.indice_remissivo.first

entrada.termo        # => "guerreiro (classe)"
entrada.pagina       # => 64
entrada.tabela       # => "classes"
entrada.registro_id  # => "guerreiro"
entrada.associado?   # => true

entrada.livro.nome        # => "Tormenta 20 - Edição Jogo do Ano"
entrada.livro.nome_curto  # => "T20 - EJA"

entrada.to_h  # Hash completo (exclui nils com compact)
```

## Associações

```ruby
# A partir de um livro
Tormenta20.livros.find("t20_eja").indice_remissivo_entries

# A partir de qualquer model via BookReferenceable
Tormenta20.classes.find("guerreiro").book_reference  # => "T20 - EJA, p. 64"
```

## BookReferenceable

O concern `BookReferenceable` está incluído em todos os models e usa o índice remissivo para resolver as referências. A busca é feita por `(tabela, registro_id)` e o resultado é memoizado por instância.

```ruby
# Todos os métodos disponíveis em qualquer model
record = Tormenta20.classes.find("arcanista")

record.book_reference  # => "T20 - EJA, p. 36"   (nil se não indexado)
record.page            # => 36
record.book            # => "T20 - EJA"
record.full_book       # => "Tormenta 20 - Edição Jogo do Ano"
```

## Exemplos

```ruby
# Páginas de todas as classes indexadas
Tormenta20.indice_remissivo
  .do_livro("t20_eja")
  .para_tabela("classes")
  .order(:pagina)
  .each { |e| puts "#{e.registro_id}: p. #{e.pagina}" }

# Termos que não estão vinculados a nenhum registro (regras gerais, locais, etc.)
Tormenta20.indice_remissivo.nao_associados.buscar_termo("combate").each do |e|
  puts "#{e.termo}: p. #{e.pagina}"
end

# Quantas entradas por tabela
Tormenta20.indice_remissivo
  .associados
  .group(:tabela)
  .count
# => { "classes" => 14, "condicoes" => 30, "origens" => 35, ... }

# Verificar se um registro está indexado
Tormenta20.classes.find("guerreiro").page  # => 64
Tormenta20.itens.first.page                # => nil (não indexado)
```
