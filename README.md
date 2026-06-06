# Tormenta20

[![Ruby](https://img.shields.io/gem/v/tormenta20)](https://rubygems.org/gems/tormenta20)
[![npm](https://img.shields.io/npm/v/tormenta20)](https://www.npmjs.com/package/tormenta20)
[![CI](https://github.com/YggdrasilGeekNetwork/tormenta20/actions/workflows/main.yml/badge.svg)](https://github.com/YggdrasilGeekNetwork/tormenta20/actions/workflows/main.yml)
[![Coverage](https://codecov.io/gh/YggdrasilGeekNetwork/tormenta20/graph/badge.svg?token=XB8BTBS6PJ)](https://codecov.io/gh/YggdrasilGeekNetwork/tormenta20)
[![Ruby Docs](https://img.shields.io/badge/docs-rubydoc.info-red)](https://rubydoc.info/gems/tormenta20)
[![TS Docs](https://img.shields.io/badge/docs-typedoc-blue)](https://luangb.github.io/tormenta20/typedoc/)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE.txt)

Uma biblioteca Ruby, TypeScript e Python com dados do RPG de mesa brasileiro Tormenta20.

Inclui um banco de dados SQLite pré-populado com magias, classes, origens, divindades, poderes, equipamentos, raças e condições do sistema T20. Todos os registros expõem referências de livro e página via `bookReference()` / `book_reference`.

## Dependências do Sistema

A biblioteca usa SQLite3. Em ambientes Linux (incluindo Docker):

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

## Instalação

**Ruby (Bundler):**

```ruby
# Gemfile
gem 'tormenta20'
```

```bash
bundle install
```

**Node.js / TypeScript:**

```bash
npm install tormenta20
```

## Uso Rápido

**Ruby:**

```ruby
require 'tormenta20'

Tormenta20.magias.arcanas.by_circle("3")
Tormenta20.classes.conjuradores.all
Tormenta20.poderes.poderes_concedidos.all
Tormenta20.racas.find('anao').book_reference  # => "T20 - EJA, p. 20"
```

**TypeScript / JavaScript:**

```ts
import { Magia, Classe, Poder, Raca } from 'tormenta20'

Magia.arcanas().all()
Classe.conjuradores().all()
Poder.poderesConcedidos().all()
Raca.find('anao')?.bookReference()  // => { formatted: "T20 - EJA, p. 20", ... }
```

## Modelos

| Model | Descrição | Qtd | Ruby | TypeScript |
|-------|-----------|-----|------|------------|
| `Magia` | Magias arcanas, divinas e universais | 198 | [docs/ruby/magias.md](docs/ruby/magias.md) | [docs/ts/magias.md](docs/ts/magias.md) |
| `Classe` | Classes de personagem | 14 | [docs/ruby/classes.md](docs/ruby/classes.md) | [docs/ts/classes.md](docs/ts/classes.md) |
| `Origem` | Origens de personagem | 35 | [docs/ruby/origens.md](docs/ruby/origens.md) | [docs/ts/origens.md](docs/ts/origens.md) |
| `Divindade` | Deuses do Panteão | 20 | [docs/ruby/divindades.md](docs/ruby/divindades.md) | [docs/ts/divindades.md](docs/ts/divindades.md) |
| `Poder` | Poderes (origem, concedido, tormenta, classe, raça) | 518 | [docs/ruby/poderes.md](docs/ruby/poderes.md) | [docs/ts/poderes.md](docs/ts/poderes.md) |
| `Raca` | Raças jogáveis | 18 | [docs/ruby/racas.md](docs/ruby/racas.md) | [docs/ts/racas.md](docs/ts/racas.md) |
| `Condicao` | Condições de status | 35 | [docs/ruby/condicoes.md](docs/ruby/condicoes.md) | [docs/ts/condicoes.md](docs/ts/condicoes.md) |
| `Arma` | Armas | — | [docs/ruby/armas.md](docs/ruby/armas.md) | [docs/ts/armas.md](docs/ts/armas.md) |
| `Armadura` | Armaduras | — | [docs/ruby/armaduras.md](docs/ruby/armaduras.md) | [docs/ts/armaduras.md](docs/ts/armaduras.md) |
| `Escudo` | Escudos | 2 | [docs/ruby/escudos.md](docs/ruby/escudos.md) | [docs/ts/escudos.md](docs/ts/escudos.md) |
| `Item` | Itens gerais | — | [docs/ruby/itens.md](docs/ruby/itens.md) | [docs/ts/itens.md](docs/ts/itens.md) |
| `MaterialEspecial` | Materiais especiais | 6 | [docs/ruby/materiais_especiais.md](docs/ruby/materiais_especiais.md) | [docs/ts/materiais_especiais.md](docs/ts/materiais_especiais.md) |
| `Melhoria` | Melhorias mágicas | — | [docs/ruby/melhorias.md](docs/ruby/melhorias.md) | [docs/ts/melhorias.md](docs/ts/melhorias.md) |
| `Regra` | Regras e dados de referência | 14 | [docs/ruby/regras.md](docs/ruby/regras.md) | [docs/ts/regras.md](docs/ts/regras.md) |
| `Livro` | Livros indexados | 1 | [docs/ruby/livros.md](docs/ruby/livros.md) | [docs/ts/livros.md](docs/ts/livros.md) |
| `IndiceRemissivo` | Entradas do índice remissivo | 1098 | [docs/ruby/indice_remissivo.md](docs/ruby/indice_remissivo.md) | [docs/ts/indice_remissivo.md](docs/ts/indice_remissivo.md) |

## Development

### Pré-requisitos

- Ruby >= 3.0.0
- Node.js >= 18
- Bundler

### Setup

```bash
git clone https://github.com/LuanGB/tormenta20.git
cd tormenta20
bundle install
npm install
```

### Construir o Banco de Dados

O arquivo `db/tormenta20.sqlite3` é **gerado** a partir dos JSONs em `src/json/`:

```bash
# Ruby
rake build_db

# Build completo (inclui build_db)
rake build

# TypeScript (compila dist/ + docs)
npm run build
npm run docs
```

### Estrutura do Projeto

```
tormenta20/
├── src/
│   ├── json/          # Dados fonte em JSON
│   ├── ruby/          # Código Ruby (ActiveRecord models)
│   └── ts/            # Código TypeScript
├── docs/
│   ├── ruby/          # Referência da API Ruby
│   └── ts/            # Referência da API TypeScript
├── db/
│   ├── schema.sql
│   └── tormenta20.sqlite3   # Gerado por rake build_db
└── dist/              # Build TypeScript compilado
```

### Testes

```bash
# Ruby
bin/test

# TypeScript
npm test
```

## Contributing

Bug reports e pull requests são bem-vindos em https://github.com/LuanGB/tormenta20.

## License

Disponível como open source sob os termos da [MIT License](https://opensource.org/licenses/MIT).

## Aviso Legal

Tormenta20 é uma marca registrada da Jambô Editora. Esta biblioteca é um projeto de fã não oficial e não é afiliada, endossada ou patrocinada pela Jambô Editora.
