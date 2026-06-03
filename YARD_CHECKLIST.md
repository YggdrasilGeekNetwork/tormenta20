# YARD / rubydoc.info Checklist

## Blocker

- [x] Criar `.yardopts` na raiz com o path correto:
  ```
  src/ruby/**/*.rb
  --readme README.md
  ```
  Sem isso, rubydoc.info gera página vazia (procura em `lib/` por padrão).

## Melhorias

- [x] Adicionar `yard` como dependência de desenvolvimento no `tormenta20.gemspec`:
  ```ruby
  spec.add_development_dependency "yard"
  ```
- [x] Adicionar task `yard` no `Rakefile`:
  ```ruby
  require "yard"
  YARD::Rake::YardocTask.new
  ```
- [x] Adicionar `"documentation_uri"` no `spec.metadata` do gemspec:
  ```ruby
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/tormenta20"
  ```

## Cobertura faltante

Modelos sem nenhuma doc YARD:

- [x] `src/ruby/tormenta20/models/raca.rb`
- [x] `src/ruby/tormenta20/models/pocao.rb`
- [x] `src/ruby/tormenta20/models/pericia.rb`
- [x] `src/ruby/tormenta20/models/livro.rb`
- [x] `src/ruby/tormenta20/models/tabela.rb`
- [x] `src/ruby/tormenta20/models/acessorio_magico.rb`
- [x] `src/ruby/tormenta20/models/base.rb` — tem comentário descritivo mas sem `@!attribute`
