# Tormenta20

[![Gem Version](https://img.shields.io/gem/v/tormenta20)](https://rubygems.org/gems/tormenta20)
[![CI](https://github.com/LuanGB/tormenta20/actions/workflows/main.yml/badge.svg)](https://github.com/LuanGB/tormenta20/actions/workflows/main.yml)
[![Coverage](https://codecov.io/gh/YggdrasilGeekNetwork/tormenta20/graph/badge.svg?token=XB8BTBS6PJ)](https://codecov.io/gh/YggdrasilGeekNetwork/tormenta20)
[![License](https://img.shields.io/github/license/LuanGB/tormenta20)](LICENSE.txt)

Uma biblioteca Ruby com dados do RPG de mesa brasileiro Tormenta20.

A gem inclui um banco de dados SQLite pré-populado com informações sobre magias, classes, origens, divindades, poderes, equipamentos, raças e condições do sistema Tormenta20. Todos os registros expõem referências de livro e página via o concern `BookReferenceable`.

## Dependências do Sistema

A gem usa SQLite3 para armazenar os dados. O driver Ruby (`sqlite3` gem) vem com binaries pré-compilados, mas em ambientes Linux (incluindo Docker) a biblioteca de runtime precisa estar presente:

```bash
# Debian/Ubuntu
apt-get install libsqlite3-0

# Alpine
apk add sqlite-libs
```

No Dockerfile da sua aplicação:

```dockerfile
RUN apt-get install --no-install-recommends -y libsqlite3-0
```

## Installation

Adicione ao Gemfile da sua aplicação:

```ruby
gem 'tormenta20'
```

E execute:

```bash
bundle install
```

Ou instale diretamente:

```bash
gem install tormenta20
```

## Usage

A gem já vem com o banco de dados populado. Basta fazer require e usar:

```ruby
require 'tormenta20'

# Magias
Tormenta20.magias.count                    # => 198
Tormenta20.magias.arcanas                  # Magias arcanas
Tormenta20.magias.divinas                  # Magias divinas
Tormenta20.magias.by_circle("3")           # Magias do 3º círculo
Tormenta20.magias.by_school('evoc')        # Magias de evocação
Tormenta20.magias.arcanas.by_circle("1")   # Combinar filtros

# Classes
Tormenta20.classes.all
Tormenta20.classes.conjuradores            # Classes com magia

# Raças
Tormenta20.racas.all
Tormenta20.racas.find('anao')

# Origens
Tormenta20.origens.all
Tormenta20.origens.find('soldado')
Tormenta20.origens.with_unique_power       # Origens com poder único

# Divindades
Tormenta20.divindades.all
Tormenta20.divindades.energia_positiva     # Deuses de energia positiva
Tormenta20.divindades.energia_negativa     # Deuses de energia negativa

# Poderes
Tormenta20.poderes.all
Tormenta20.poderes.habilidades_unicas      # Habilidades únicas de origem
Tormenta20.poderes.poderes_concedidos      # Poderes concedidos por divindades
Tormenta20.poderes.poderes_tormenta        # Poderes da Tormenta

# Condições
Tormenta20.condicoes.all
Tormenta20.condicoes.by_type('medo')
Tormenta20.condicoes.medo
Tormenta20.condicoes.mental

# Equipamentos
Tormenta20.armas.all
Tormenta20.armas.simples                   # Armas simples
Tormenta20.armas.marciais                  # Armas marciais
Tormenta20.armaduras.all
Tormenta20.armaduras.leves                 # Armaduras leves
Tormenta20.escudos.all

# Itens Superiores
Tormenta20.materiais_especiais.all
Tormenta20.melhorias.all

# Regras
Tormenta20.regras.all

# Índice Remissivo
Tormenta20.livros.all
Tormenta20.indice_remissivo.do_livro('t20_eja')
Tormenta20.indice_remissivo.para_tabela('classes')
Tormenta20.indice_remissivo.buscar_termo('Fúria')
```

### Query Interface

A gem oferece uma interface de consulta simplificada. Todos os métodos retornam modelos ActiveRecord, permitindo encadeamento de scopes e queries:

```ruby
# Accessors disponíveis
Tormenta20.origens              # => Tormenta20::Models::Origem
Tormenta20.poderes              # => Tormenta20::Models::Poder
Tormenta20.divindades           # => Tormenta20::Models::Divindade
Tormenta20.classes              # => Tormenta20::Models::Classe
Tormenta20.magias               # => Tormenta20::Models::Magia
Tormenta20.armas                # => Tormenta20::Models::Arma
Tormenta20.armaduras            # => Tormenta20::Models::Armadura
Tormenta20.escudos              # => Tormenta20::Models::Escudo
Tormenta20.itens                # => Tormenta20::Models::Item
Tormenta20.materiais_especiais  # => Tormenta20::Models::MaterialEspecial
Tormenta20.melhorias            # => Tormenta20::Models::Melhoria
Tormenta20.regras               # => Tormenta20::Models::Regra
Tormenta20.racas                # => Tormenta20::Models::Raca
Tormenta20.condicoes            # => Tormenta20::Models::Condicao
Tormenta20.livros               # => Tormenta20::Models::Livro
Tormenta20.indice_remissivo     # => Tormenta20::Models::IndiceRemissivo

# Exemplos de queries ActiveRecord
Tormenta20.magias.where(type: 'arcana')
Tormenta20.magias.where(school: 'evoc').order(:name)
Tormenta20.poderes.where("name LIKE ?", "%Fúria%")
```

### Models Disponíveis

| Model | Descrição | Quantidade | Documentação |
|-------|-----------|------------|--------------|
| `Magia` | Magias arcanas, divinas e universais | 198 | [docs/magias.md](docs/magias.md) |
| `Classe` | Classes de personagem | 14 | [docs/classes.md](docs/classes.md) |
| `Origem` | Origens de personagem | 35 | [docs/origens.md](docs/origens.md) |
| `Divindade` | Deuses do Panteão | 20 | [docs/divindades.md](docs/divindades.md) |
| `Poder` | Poderes (habilidades únicas, concedidos, tormenta, classe, raça) | 518 | [docs/poderes.md](docs/poderes.md) |
| `Raca` | Raças jogáveis | 18 | [docs/racas.md](docs/racas.md) |
| `Condicao` | Condições de status | 35 | [docs/condicoes.md](docs/condicoes.md) |
| `Arma` | Armas | - | [docs/armas.md](docs/armas.md) |
| `Armadura` | Armaduras | - | [docs/armaduras.md](docs/armaduras.md) |
| `Escudo` | Escudos | 2 | [docs/escudos.md](docs/escudos.md) |
| `Item` | Itens gerais | - | [docs/itens.md](docs/itens.md) |
| `MaterialEspecial` | Materiais especiais | 6 | [docs/materiais_especiais.md](docs/materiais_especiais.md) |
| `Melhoria` | Melhorias mágicas | - | [docs/melhorias.md](docs/melhorias.md) |
| `Regra` | Regras e dados de referência | 14 | [docs/regras.md](docs/regras.md) |
| `Livro` | Livros indexados | 1 | [docs/livros.md](docs/livros.md) |
| `IndiceRemissivo` | Entradas do índice remissivo | 1098 | [docs/indice_remissivo.md](docs/indice_remissivo.md) |

### Referência de Livro e Página

Todos os modelos incluem o concern `BookReferenceable`. Se o registro estiver indexado no índice remissivo, os seguintes métodos ficam disponíveis:

```ruby
guerreiro = Tormenta20.classes.find('guerreiro')

guerreiro.book_reference  # => "T20 - EJA, p. 64"
guerreiro.page            # => 64
guerreiro.book            # => "T20 - EJA"
guerreiro.full_book       # => "Tormenta 20 - Edição Jogo do Ano"

# Retorna nil se o registro não estiver no índice
item_sem_indice = Tormenta20.itens.first
item_sem_indice.book_reference  # => nil
```

O resultado é memoizado por instância — o banco é consultado apenas uma vez por objeto.

Os dados do índice remissivo são carregados de `src/json/indice_remissivo/<livro_id>.json`. Atualmente inclui o índice de **Tormenta 20 - Edição Jogo do Ano** (`t20_eja`) com mais de 1000 entradas.

### Índice Remissivo

O model `IndiceRemissivo` permite buscar entradas por livro, tabela ou termo:

```ruby
# Todas as entradas de um livro
Tormenta20.indice_remissivo.do_livro('t20_eja')

# Entradas vinculadas a uma tabela específica
Tormenta20.indice_remissivo.para_tabela('classes')

# Entradas vinculadas a registros concretos
Tormenta20.indice_remissivo.associados

# Entradas sem vínculo a registro
Tormenta20.indice_remissivo.nao_associados

# Busca por termo
Tormenta20.indice_remissivo.buscar_termo('Fúria')

# Consultar o livro de uma entrada
entrada = Tormenta20.indice_remissivo.first
entrada.livro.nome        # => "Tormenta 20 - Edição Jogo do Ano"
entrada.livro.nome_curto  # => "T20 - EJA"
```

### Exemplos

```ruby
# Buscar uma magia específica
bola_de_fogo = Tormenta20.magias.find('bola_de_fogo')
puts bola_de_fogo.name            # => "Bola de Fogo"
puts bola_de_fogo.circle          # => "3"
puts bola_de_fogo.school          # => "evoc"
puts bola_de_fogo.book_reference  # => "T20 - EJA, p. ..."

# Listar poderes de uma divindade
khalmyr = Tormenta20.divindades.find('khalmyr')
puts khalmyr.name             # => "Khalmyr"
puts khalmyr.granted_powers   # => ["coragem_total", "espada_justiceira", ...]
puts khalmyr.book_reference   # => "T20 - EJA, p. 99"

# Classe com informações de magia e referência de livro
mago = Tormenta20.classes.find('arcanista')
puts mago.initial_hp          # PV inicial
puts mago.mp_per_level        # PM por nível
puts mago.conjurador?         # => true
puts mago.book_reference      # => "T20 - EJA, p. 36"

# Raça com bônus de atributo
anao = Tormenta20.racas.find('anao')
puts anao.attribute_bonus_for('constituicao')  # => 2
puts anao.visao_no_escuro?                     # => true
puts anao.book_reference                       # => "T20 - EJA, p. 20"

# Filtrar magias arcanas do 1º círculo da escola de evocação
Tormenta20.magias.arcanas.by_circle("1").by_school("evoc").each do |magia|
  puts "#{magia.name} - #{magia.book_reference}"
end

# Condições de medo
Tormenta20.condicoes.medo.each do |c|
  puts "#{c.name}: #{c.escalates_to ? "escala para #{c.escalates_to}" : 'não escala'}"
end
```

## Development

### Pré-requisitos

- Ruby >= 3.0.0
- Bundler

### Setup

```bash
git clone https://github.com/LuanGB/tormenta20.git
cd tormenta20
bundle install
```

### Construir o Banco de Dados

O arquivo `db/tormenta20.sqlite3` é **gerado** a partir dos JSONs em `src/json/` e não está versionado no repositório. É necessário gerá-lo antes de rodar os specs ou a gem localmente:

```bash
# Construir apenas o banco
rake build_db

# Build completo da gem (inclui build_db automaticamente)
rake build
```

Os specs (`rake spec` / `rake`) também executam `build_db` automaticamente antes de rodar.

### Estrutura do Projeto

```
tormenta20/
├── src/
│   ├── json/                    # Dados em formato JSON
│   │   ├── magias/
│   │   ├── classes/
│   │   ├── origens/
│   │   ├── deuses/
│   │   ├── poderes/
│   │   │   ├── habilidades_unicas_de_origem/
│   │   │   ├── poderes_concedidos/
│   │   │   └── poderes_da_tormenta/
│   │   ├── equipamentos/
│   │   ├── itens_superiores/
│   │   ├── regras/
│   │   ├── condicoes/
│   │   ├── racas/
│   │   ├── livros/
│   │   └── indice_remissivo/    # Índice por livro (ex: t20_eja.json)
│   └── ruby/                    # Código Ruby
│       └── tormenta20/
│           ├── models/          # ActiveRecord models
│           ├── concerns/        # Mixins (BookReferenceable)
│           ├── database.rb      # Conexão com banco
│           └── seeder.rb        # Import de dados
├── db/
│   ├── schema.sql              # Schema SQLite
│   ├── seeds.rb                # Script de seed (desenvolvimento)
│   └── tormenta20.sqlite3      # Banco pré-construído (gerado)
└── bin/
    └── build_db                # Script de build do banco
```

### Testes

```bash
bin/test
```

Ou individualmente:

```bash
# Apenas specs
bundle exec rspec

# Suite completa (build_db + specs + rubocop + jsonlint)
bin/ci
```

### Linting

```bash
rake rubocop
```

## Contributing

Bug reports e pull requests são bem-vindos em https://github.com/LuanGB/tormenta20.

## License

Disponível como open source sob os termos da [MIT License](https://opensource.org/licenses/MIT).

## Aviso Legal

Tormenta20 é uma marca registrada da Jambô Editora. Esta biblioteca é um projeto de fã não oficial e não é afiliada, endossada ou patrocinada pela Jambô Editora.
