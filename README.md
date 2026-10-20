# Tormenta20

[![Ruby](https://img.shields.io/gem/v/tormenta20)](https://rubygems.org/gems/tormenta20)
[![npm](https://img.shields.io/npm/v/tormenta20)](https://www.npmjs.com/package/tormenta20)
[![CI](https://github.com/YggdrasilGeekNetwork/tormenta20/actions/workflows/main.yml/badge.svg)](https://github.com/YggdrasilGeekNetwork/tormenta20/actions/workflows/main.yml)
[![Coverage](https://codecov.io/gh/YggdrasilGeekNetwork/tormenta20/graph/badge.svg?token=XB8BTBS6PJ)](https://codecov.io/gh/YggdrasilGeekNetwork/tormenta20)
[![Ruby Docs](https://img.shields.io/badge/docs-rubydoc.info-red)](https://rubydoc.info/gems/tormenta20)
[![Docs](https://img.shields.io/badge/docs-online-blue)](https://yggdrasilgeeknetwork.github.io/tormenta20/)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE.txt)

Uma biblioteca Ruby e TypeScript com dados do RPG de mesa brasileiro Tormenta20.

Inclui um banco de dados SQLite pré-populado com o conteúdo mecânico do livro básico e de quatro suplementos: raças, classes, origens, poderes, magias, divindades, equipamentos, itens mágicos, bases e domínios, bestiário, condições, regras e tabelas.

## Livros

| `livro_id` | Livro | Conteúdo |
|------------|-------|----------|
| `t20_eja` | Tormenta20 — Edição Jogo do Ano | Livro básico |
| `herois_de_arton` | Heróis de Arton | Raças, Treinador, classes variantes, origens, distinções, complicações, poderes, equipamentos, itens mágicos, bases e domínios |
| `deuses_de_arton` | Deuses de Arton | Deuses menores, Frade, poderes concedidos, distinções, itens litúrgicos, artefatos, magias |
| `ameacas_de_arton` | Ameaças de Arton | Bestiário, raças jogáveis, montarias, mascotes e familiares, equipamentos, regras de ameaças, tabelas de encontros |
| `atlas_de_arton` | Atlas de Arton | 66 origens regionais (o restante do livro é ambientação e não está incluído) |

Todo registro tem `livro_id`. No Ruby, qualquer modelo aceita o scope `do_livro`; no TypeScript, use `query().where("livro_id = ?", ...)`.

Referências de página (`book_reference` / `bookReference()`) vêm do índice remissivo do livro básico, que hoje liga raças, classes, origens, divindades, condições, armas, armaduras e materiais especiais. Nos demais casos, elas retornam `nil`/`null`.

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

Tormenta20.magias.arcanas.by_circle(3)
Tormenta20.classes.find("arcanista").initial_hp
Tormenta20.poderes.by_class("guerreiro")
Tormenta20.ameacas.up_to_nd(2).by_grupo("ermos")
Tormenta20.origens.do_livro("atlas_de_arton").count  # => 66
Tormenta20.racas.find('anao').book_reference  # => "T20 - EJA, p. 20"
```

**TypeScript / JavaScript:**

```ts
import { Magia, Classe, Poder, Ameaca, Origem, Raca } from 'tormenta20'

Magia.arcanas().where("circle = ?", "3").all()
Classe.find("arcanista")?.initialHp
Poder.byClass("guerreiro").all()
Ameaca.upToNd(2).where("grupo = ?", "ermos").all()
Origem.query().where("livro_id = ?", "atlas_de_arton").count()  // 66
Raca.find('anao')?.bookReference()  // { livro: "...", pagina: 20, formatted: "T20 - EJA, p. 20" }
```

## Modelos

### Personagem

| Modelo | Ruby | TypeScript | Qtd |
|--------|------|------------|-----|
| Raças | [`Tormenta20.racas`](docs/ruby/racas.md) | [`Raca`](docs/ts/racas.md) | 50 |
| Classes | [`Tormenta20.classes`](docs/ruby/classes.md) | [`Classe`](docs/ts/classes.md) | 16 |
| Classes Variantes | [`Tormenta20.classes_variantes`](docs/ruby/classes_variantes.md) | [`ClasseVariante`](docs/ts/classes_variantes.md) | 14 |
| Origens | [`Tormenta20.origens`](docs/ruby/origens.md) | [`Origem`](docs/ts/origens.md) | 131 |
| Perícias | [`Tormenta20.pericias`](docs/ruby/pericias.md) | [`Pericia`](docs/ts/pericias.md) | 29 |
| Poderes | [`Tormenta20.poderes`](docs/ruby/poderes.md) | [`Poder`](docs/ts/poderes.md) | 1841 |
| Distinções | [`Tormenta20.distincoes`](docs/ruby/distincoes.md) | [`Distincao`](docs/ts/distincoes.md) | 59 |
| Complicações | [`Tormenta20.complicacoes`](docs/ruby/complicacoes.md) | [`Complicacao`](docs/ts/complicacoes.md) | 54 |
| Divindades | [`Tormenta20.divindades`](docs/ruby/divindades.md) | [`Divindade`](docs/ts/divindades.md) | 23 |

### Magia

| Modelo | Ruby | TypeScript | Qtd |
|--------|------|------------|-----|
| Magias | [`Tormenta20.magias`](docs/ruby/magias.md) | [`Magia`](docs/ts/magias.md) | 252 |

### Equipamento

| Modelo | Ruby | TypeScript | Qtd |
|--------|------|------------|-----|
| Armas | [`Tormenta20.armas`](docs/ruby/armas.md) | [`Arma`](docs/ts/armas.md) | 96 |
| Armaduras | [`Tormenta20.armaduras`](docs/ruby/armaduras.md) | [`Armadura`](docs/ts/armaduras.md) | 23 |
| Escudos | [`Tormenta20.escudos`](docs/ruby/escudos.md) | [`Escudo`](docs/ts/escudos.md) | 7 |
| Itens | [`Tormenta20.itens`](docs/ruby/itens.md) | [`Item`](docs/ts/itens.md) | 388 |
| Materiais Especiais | [`Tormenta20.materiais_especiais`](docs/ruby/materiais_especiais.md) | [`MaterialEspecial`](docs/ts/materiais_especiais.md) | 14 |
| Melhorias | [`Tormenta20.melhorias`](docs/ruby/melhorias.md) | [`Melhoria`](docs/ts/melhorias.md) | 48 |
| Encantamentos | [`Tormenta20.encantamentos`](docs/ruby/encantamentos.md) | [`Encantamento`](docs/ts/encantamentos.md) | 161 |

### Itens mágicos

| Modelo | Ruby | TypeScript | Qtd |
|--------|------|------------|-----|
| Poções | [`Tormenta20.pocoes`](docs/ruby/pocoes.md) | [`Pocao`](docs/ts/pocoes.md) | 38 |
| Acessórios Mágicos | [`Tormenta20.acessorios`](docs/ruby/acessorios_magicos.md) | [`AcessorioMagico`](docs/ts/acessorios_magicos.md) | 137 |
| Esotéricos Mágicos | [`Tormenta20.esotericos`](docs/ruby/esotericos_magicos.md) | [`EsotericoMagico`](docs/ts/esotericos_magicos.md) | 4 |
| Armas Mágicas Específicas | [`Tormenta20.armas_magicas`](docs/ruby/armas_magicas.md) | [`ArmaMagicaEspecifica`](docs/ts/armas_magicas.md) | 38 |
| Armaduras Mágicas Específicas | [`Tormenta20.armaduras_magicas`](docs/ruby/armaduras_magicas.md) | [`ArmaduraMagicaEspecifica`](docs/ts/armaduras_magicas.md) | 25 |
| Itens Litúrgicos | [`Tormenta20.itens_liturgicos`](docs/ruby/itens_liturgicos.md) | [`ItemLiturgico`](docs/ts/itens_liturgicos.md) | 35 |
| Artefatos | [`Tormenta20.artefatos`](docs/ruby/artefatos.md) | [`Artefato`](docs/ts/artefatos.md) | 32 |

### Bases e domínios

| Modelo | Ruby | TypeScript | Qtd |
|--------|------|------------|-----|
| Tipos de Base | [`Tormenta20.bases_tipos`](docs/ruby/bases_tipos.md) | [`BaseTipo`](docs/ts/bases_tipos.md) | 6 |
| Cômodos | [`Tormenta20.comodos`](docs/ruby/comodos.md) | [`Comodo`](docs/ts/comodos.md) | 41 |
| Mobílias | [`Tormenta20.mobilias`](docs/ruby/mobilias.md) | [`Mobilia`](docs/ts/mobilias.md) | 25 |
| Construções de Domínio | [`Tormenta20.construcoes_dominio`](docs/ruby/construcoes_dominio.md) | [`ConstrucaoDominio`](docs/ts/construcoes_dominio.md) | 80 |

### Bestiário

| Modelo | Ruby | TypeScript | Qtd |
|--------|------|------------|-----|
| Ameaças | [`Tormenta20.ameacas`](docs/ruby/ameacas.md) | [`Ameaca`](docs/ts/ameacas.md) | 564 |

### Regras e referência

| Modelo | Ruby | TypeScript | Qtd |
|--------|------|------------|-----|
| Condições | [`Tormenta20.condicoes`](docs/ruby/condicoes.md) | [`Condicao`](docs/ts/condicoes.md) | 35 |
| Regras | [`Tormenta20.regras`](docs/ruby/regras.md) | [`Regra`](docs/ts/regras.md) | 77 |
| Tabelas | [`Tormenta20.tabelas`](docs/ruby/tabelas.md) | [`Tabela`](docs/ts/tabelas.md) | 51 |
| Livros | [`Tormenta20.livros`](docs/ruby/livros.md) | [`Livro`](docs/ts/livros.md) | 5 |
| Índice Remissivo | [`Tormenta20.indice_remissivo`](docs/ruby/indice_remissivo.md) | [`IndiceRemissivo`](docs/ts/indice_remissivo.md) | 1098 |

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

O arquivo `db/tormenta20.sqlite3` é **gerado** a partir dos JSONs em `src/json/`. Há dois geradores equivalentes, um por linguagem, e os dois devem produzir o mesmo banco:

```bash
# Ruby (bin/build_db)
rake build_db

# TypeScript (src/ts/seeder.ts)
npm run seed

# Build completo da gem (inclui build_db)
rake build

# TypeScript: compila dist/ e gera a TypeDoc
npm run build
npm run docs
```

Ao mudar o formato de um JSON ou o schema, atualize `bin/build_db` e `src/ts/seeder.ts` juntos.

### Estrutura do Projeto

```
tormenta20/
├── src/
│   ├── json/          # Dados fonte em JSON (um arquivo por registro; `livro` indica o suplemento)
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
