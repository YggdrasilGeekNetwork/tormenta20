# Tormenta20

Uma biblioteca Ruby com dados do RPG de mesa brasileiro Tormenta20.

A gem inclui um banco de dados SQLite pré-populado com informações sobre magias, classes, origens, divindades, poderes e equipamentos do sistema Tormenta20.

## Installation

Adicione ao Gemfile da sua aplicacao:

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

A gem ja vem com o banco de dados populado. Basta fazer require e usar:

```ruby
require 'tormenta20'

# Magias
Tormenta20.magias.count                    # => 198
Tormenta20.magias.arcanas                  # Magias arcanas
Tormenta20.magias.divinas                  # Magias divinas
Tormenta20.magias.by_circle("3")           # Magias do 3o circulo
Tormenta20.magias.by_school('evoc')        # Magias de evocacao
Tormenta20.magias.arcanas.by_circle("1")   # Combinar filtros

# Classes
Tormenta20.classes.all
Tormenta20.classes.conjuradores            # Classes com magia

# Origens
Tormenta20.origens.all
Tormenta20.origens.find('soldado')
Tormenta20.origens.with_unique_power       # Origens com poder unico

# Divindades
Tormenta20.divindades.all
Tormenta20.divindades.energia_positiva     # Deuses de energia positiva
Tormenta20.divindades.energia_negativa     # Deuses de energia negativa

# Poderes
Tormenta20.poderes.all
Tormenta20.poderes.habilidades_unicas      # Habilidades unicas de origem
Tormenta20.poderes.poderes_concedidos      # Poderes concedidos por divindades
Tormenta20.poderes.poderes_tormenta        # Poderes da Tormenta

# Equipamentos
Tormenta20.armas.all
Tormenta20.armas.simples                   # Armas simples
Tormenta20.armas.marciais                  # Armas marciais
Tormenta20.armaduras.all
Tormenta20.armaduras.leves                 # Armaduras leves
Tormenta20.escudos.all

# Itens Superiores
Tormenta20.materiais_especiais.all

# Regras
Tormenta20.regras.all
```

### Query Interface

A gem oferece uma interface de consulta simplificada. Todos os metodos retornam modelos ActiveRecord, permitindo encadeamento de scopes e queries:

```ruby
# Accessors disponiveis
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

# Exemplos de queries ActiveRecord
Tormenta20.magias.where(type: 'arcana')
Tormenta20.magias.where(school: 'evoc').order(:name)
Tormenta20.poderes.where("name LIKE ?", "%Furia%")
```

### Models Disponiveis

| Model | Descricao | Quantidade | Documentacao |
|-------|-----------|------------|--------------|
| `Magia` | Magias arcanas, divinas e universais | 198 | [docs/magias.md](docs/magias.md) |
| `Classe` | Classes de personagem | 14 | [docs/classes.md](docs/classes.md) |
| `Origem` | Origens de personagem | 35 | [docs/origens.md](docs/origens.md) |
| `Divindade` | Deuses do Panteao | 20 | [docs/divindades.md](docs/divindades.md) |
| `Poder` | Poderes (habilidades unicas, concedidos, tormenta) | 129 | [docs/poderes.md](docs/poderes.md) |
| `Arma` | Armas | - | [docs/armas.md](docs/armas.md) |
| `Armadura` | Armaduras | - | [docs/armaduras.md](docs/armaduras.md) |
| `Escudo` | Escudos | 2 | [docs/escudos.md](docs/escudos.md) |
| `Item` | Itens gerais | - | [docs/itens.md](docs/itens.md) |
| `MaterialEspecial` | Materiais especiais | 6 | [docs/materiais_especiais.md](docs/materiais_especiais.md) |
| `Melhoria` | Melhorias magicas | - | [docs/melhorias.md](docs/melhorias.md) |
| `Regra` | Regras e dados de referencia | 14 | [docs/regras.md](docs/regras.md) |

> Cada link de documentacao contem a lista completa de atributos, scopes, metodos e exemplos de uso.

### Exemplos

```ruby
# Buscar uma magia especifica
bola_de_fogo = Tormenta20.magias.find('bola_de_fogo')
puts bola_de_fogo.name        # => "Bola de Fogo"
puts bola_de_fogo.circle      # => "3"
puts bola_de_fogo.school      # => "evoc"
puts bola_de_fogo.description

# Listar poderes de uma divindade
khalmyr = Tormenta20.divindades.find('khalmyr')
puts khalmyr.name             # => "Khalmyr"
puts khalmyr.granted_powers   # => ["coragem_total", "espada_justiceira", ...]

# Buscar poderes concedidos
Tormenta20.poderes.poderes_concedidos.each do |poder|
  puts "#{poder.name}: #{poder.deities.join(', ')}"
end

# Classe com informacoes de magia
mago = Tormenta20.classes.find('arcanista')
puts mago.initial_hp          # PV inicial
puts mago.mp_per_level        # PM por nivel
puts mago.conjurador?         # => true

# Filtrar magias arcanas do 1o circulo da escola de evocacao
Tormenta20.magias.arcanas.by_circle("1").by_school("evoc").each do |magia|
  puts "#{magia.name} - #{magia.description}"
end
```

## Development

### Pre-requisitos

- Ruby >= 3.0.0
- Bundler

### Setup

```bash
git clone https://github.com/LuanGB/tormenta20.git
cd tormenta20
bundle install
```

### Construir o Banco de Dados

O banco de dados SQLite e construido a partir dos arquivos JSON em `src/json/`:

```bash
# Construir apenas o banco
rake build_db

# Build completo da gem (inclui build_db automaticamente)
rake build
```

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
│   │   └── regras/
│   └── ruby/                    # Codigo Ruby
│       └── tormenta20/
│           ├── models/          # ActiveRecord models
│           ├── database.rb      # Conexao com banco
│           └── seeder.rb        # Import de dados
├── db/
│   ├── schema.sql              # Schema SQLite
│   ├── seeds.rb                # Script de seed (desenvolvimento)
│   └── tormenta20.sqlite3      # Banco pre-construido (gerado)
└── bin/
    └── build_db                # Script de build do banco
```

### Testes

```bash
rake spec
```

### Linting

```bash
rake rubocop
```

## Contributing

Bug reports e pull requests sao bem-vindos em https://github.com/LuanGB/tormenta20.

## License

Disponivel como open source sob os termos da [MIT License](https://opensource.org/licenses/MIT).

## Aviso Legal

Tormenta20 e uma marca registrada da Jambo Editora. Esta biblioteca e um projeto de fa nao oficial e nao e afiliada, endossada ou patrocinada pela Jambo Editora.
