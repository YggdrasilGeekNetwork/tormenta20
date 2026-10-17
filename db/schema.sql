-- =============================================================================
-- TORMENTA 20 SQLITE SCHEMA
-- =============================================================================
-- Schema para todos os tipos de dados do sistema Tormenta 20
-- Usa SQLite com JSON para campos flexíveis
-- =============================================================================

-- -----------------------------------------------------------------------------
-- ORIGENS (Character Origins)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS origens (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  items JSON DEFAULT '[]',
  benefits JSON DEFAULT '{}',
  unique_power TEXT,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_origens_livro ON origens(livro_id);

CREATE INDEX IF NOT EXISTS idx_origens_name ON origens(name);

CREATE TRIGGER IF NOT EXISTS update_origens_timestamp
AFTER UPDATE ON origens
BEGIN
  UPDATE origens SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- PODERES (Powers) - Tabela unificada para todos os tipos de poderes
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS poderes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN (
    'habilidade_unica_origem',
    'poder_concedido',
    'poder_tormenta',
    'poder_classe',
    'habilidade_de_raca',
    'poder_geral',
    'poder_combate',
    'poder_destino',
    'poder_magia',
    'poder_de_raca',
    'poder_de_grupo',
    'poder_distincao'
  )),
  description TEXT,
  effects JSON DEFAULT '[]',
  costs JSON DEFAULT '[]',
  prerequisites JSON DEFAULT '[]',
  origin_id TEXT,
  class_id TEXT,
  distincao_id TEXT REFERENCES distincoes(id), -- set only when type = 'poder_distincao'
  deities JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_poderes_livro ON poderes(livro_id);

CREATE INDEX IF NOT EXISTS idx_poderes_type ON poderes(type);
CREATE INDEX IF NOT EXISTS idx_poderes_name ON poderes(name);
CREATE INDEX IF NOT EXISTS idx_poderes_origin ON poderes(origin_id);
CREATE INDEX IF NOT EXISTS idx_poderes_distincao ON poderes(distincao_id);

CREATE TRIGGER IF NOT EXISTS update_poderes_timestamp
AFTER UPDATE ON poderes
BEGIN
  UPDATE poderes SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- DIVINDADES (Deities)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS divindades (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  title TEXT,
  description TEXT,
  beliefs_objectives JSON DEFAULT '[]',
  holy_symbol TEXT,
  energy TEXT NOT NULL DEFAULT 'qualquer' CHECK(energy IN ('positiva', 'negativa', 'qualquer')),
  preferred_weapon TEXT,
  devotees JSON DEFAULT '{}',
  granted_powers JSON DEFAULT '[]',
  obligations_restrictions TEXT,
  rank TEXT DEFAULT 'maior' CHECK(rank IN ('maior', 'menor')),
  natureza TEXT, -- deuses menores apenas: conceito_vivo | entidade_primordial | dragao_real | mortal_ascendido | objeto_desperto
  status_divino INTEGER, -- deuses menores apenas: 1 a 5
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_divindades_livro ON divindades(livro_id);

CREATE INDEX IF NOT EXISTS idx_divindades_name ON divindades(name);
CREATE INDEX IF NOT EXISTS idx_divindades_energy ON divindades(energy);

CREATE TRIGGER IF NOT EXISTS update_divindades_timestamp
AFTER UPDATE ON divindades
BEGIN
  UPDATE divindades SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- CLASSES (Character Classes)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS classes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  hit_points JSON NOT NULL,
  mana_points JSON NOT NULL,
  skills JSON NOT NULL,
  proficiencies JSON NOT NULL,
  abilities JSON DEFAULT '[]',
  powers JSON DEFAULT '[]',
  progression JSON DEFAULT '[]',
  spellcasting JSON,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_classes_livro ON classes(livro_id);

CREATE INDEX IF NOT EXISTS idx_classes_name ON classes(name);

CREATE TRIGGER IF NOT EXISTS update_classes_timestamp
AFTER UPDATE ON classes
BEGIN
  UPDATE classes SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- MAGIAS (Spells)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS magias (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('arcana', 'divina', 'universal')),
  circle TEXT NOT NULL,
  school TEXT NOT NULL CHECK(school IN ('abjur', 'adiv', 'conv', 'encan', 'evoc', 'ilus', 'necro', 'trans')),
  execution TEXT NOT NULL,
  execution_details TEXT,
  range TEXT NOT NULL,
  duration TEXT NOT NULL,
  duration_details TEXT,
  counterspell TEXT,
  description TEXT NOT NULL,

  -- Target information
  target_amount INTEGER,
  target_up_to INTEGER,
  target_type TEXT,

  -- Effect information
  effect TEXT,
  effect_shape TEXT,
  effect_dimention TEXT,
  effect_size TEXT,
  effect_other_details TEXT,

  -- Alternative effect fields
  area_effect TEXT,
  area_effect_details TEXT,

  -- Resistance information
  resistence_effect TEXT,
  resistence_skill TEXT,

  -- Extra costs
  extra_costs_material_component TEXT,
  extra_costs_material_cost TEXT,
  extra_costs_pm_debuff TEXT,
  extra_costs_pm_sacrifice TEXT,

  -- Complex nested data stored as JSON
  enhancements JSON NOT NULL DEFAULT '[]',
  effects JSON NOT NULL DEFAULT '[]',

  -- Metadata
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_magias_livro ON magias(livro_id);

CREATE INDEX IF NOT EXISTS idx_magias_type ON magias(type);
CREATE INDEX IF NOT EXISTS idx_magias_circle ON magias(circle);
CREATE INDEX IF NOT EXISTS idx_magias_school ON magias(school);
CREATE INDEX IF NOT EXISTS idx_magias_name ON magias(name);

CREATE TRIGGER IF NOT EXISTS update_magias_timestamp
AFTER UPDATE ON magias
BEGIN
  UPDATE magias SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ARMAS (Weapons)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS armas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL CHECK(category IN ('simples', 'marciais', 'exoticas', 'fogo')),
  price INTEGER,
  damage TEXT,
  damage_type TEXT,
  critical TEXT,
  range TEXT,
  weight REAL,
  properties JSON DEFAULT '[]',
  description TEXT,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_armas_livro ON armas(livro_id);

CREATE INDEX IF NOT EXISTS idx_armas_category ON armas(category);
CREATE INDEX IF NOT EXISTS idx_armas_name ON armas(name);

CREATE TRIGGER IF NOT EXISTS update_armas_timestamp
AFTER UPDATE ON armas
BEGIN
  UPDATE armas SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ARMADURAS (Armors)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS armaduras (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL CHECK(category IN ('leve', 'pesada')),
  price INTEGER,
  defense_bonus INTEGER NOT NULL,
  armor_penalty INTEGER DEFAULT 0,
  weight REAL,
  properties JSON DEFAULT '[]',
  description TEXT,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_armaduras_livro ON armaduras(livro_id);

CREATE INDEX IF NOT EXISTS idx_armaduras_category ON armaduras(category);
CREATE INDEX IF NOT EXISTS idx_armaduras_name ON armaduras(name);

CREATE TRIGGER IF NOT EXISTS update_armaduras_timestamp
AFTER UPDATE ON armaduras
BEGIN
  UPDATE armaduras SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ESCUDOS (Shields)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS escudos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  price INTEGER,
  defense_bonus INTEGER NOT NULL,
  armor_penalty INTEGER DEFAULT 0,
  weight REAL,
  properties JSON DEFAULT '[]',
  description TEXT,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_escudos_livro ON escudos(livro_id);

CREATE INDEX IF NOT EXISTS idx_escudos_name ON escudos(name);

CREATE TRIGGER IF NOT EXISTS update_escudos_timestamp
AFTER UPDATE ON escudos
BEGIN
  UPDATE escudos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ITENS GERAIS (General Items)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS itens (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT,
  price INTEGER,
  weight REAL,
  description TEXT,
  effects JSON DEFAULT '{}',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_itens_livro ON itens(livro_id);

CREATE INDEX IF NOT EXISTS idx_itens_category ON itens(category);
CREATE INDEX IF NOT EXISTS idx_itens_name ON itens(name);

CREATE TRIGGER IF NOT EXISTS update_itens_timestamp
AFTER UPDATE ON itens
BEGIN
  UPDATE itens SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS SUPERIORES - MATERIAIS ESPECIAIS (Special Materials)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS materiais_especiais (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  applicable_to JSON DEFAULT '[]',
  price_modifier JSON,
  effects JSON DEFAULT '{}',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_materiais_especiais_livro ON materiais_especiais(livro_id);

CREATE INDEX IF NOT EXISTS idx_materiais_especiais_name ON materiais_especiais(name);

CREATE TRIGGER IF NOT EXISTS update_materiais_especiais_timestamp
AFTER UPDATE ON materiais_especiais
BEGIN
  UPDATE materiais_especiais SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS SUPERIORES - ENCANTAMENTOS (Enchantments)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS encantamentos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  categoria TEXT NOT NULL,           -- 'arma' | 'armadura' | 'esoterico' | 'acessorio'
  escudo_only INTEGER DEFAULT 0,     -- boolean: only for shields
  conta_como_dois INTEGER DEFAULT 0, -- boolean: counts as two enchantments
  maldicao INTEGER DEFAULT 0,        -- boolean: item amaldiçoado (efeito negativo), não um encanto positivo
  prerequisitos JSON DEFAULT '[]',
  effects JSON DEFAULT '[]',         -- array of typed mechanical effect objects
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_encantamentos_livro ON encantamentos(livro_id);

CREATE INDEX IF NOT EXISTS idx_encantamentos_categoria ON encantamentos(categoria);

CREATE TRIGGER IF NOT EXISTS update_encantamentos_timestamp
AFTER UPDATE ON encantamentos
BEGIN
  UPDATE encantamentos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS SUPERIORES - MELHORIAS (Enhancements)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS melhorias (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  applicable_to JSON DEFAULT '[]',
  price INTEGER,
  effects JSON DEFAULT '[]', -- array of typed mechanical effect objects
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_melhorias_livro ON melhorias(livro_id);

CREATE INDEX IF NOT EXISTS idx_melhorias_name ON melhorias(name);

CREATE TRIGGER IF NOT EXISTS update_melhorias_timestamp
AFTER UPDATE ON melhorias
BEGIN
  UPDATE melhorias SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- REGRAS (Rules/Reference Data)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS regras (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  data JSON NOT NULL,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_regras_livro ON regras(livro_id);

CREATE INDEX IF NOT EXISTS idx_regras_name ON regras(name);

CREATE TRIGGER IF NOT EXISTS update_regras_timestamp
AFTER UPDATE ON regras
BEGIN
  UPDATE regras SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- RAÇAS (Playable Races)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS racas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  size TEXT NOT NULL DEFAULT 'médio',
  movement INTEGER NOT NULL DEFAULT 9,
  vision TEXT DEFAULT 'normal',
  vision_range INTEGER,
  attribute_bonuses JSON DEFAULT '{}',
  chosen_attribute_bonus JSON, -- { count, value, exclude: [...] } — "escolha N atributos" (Heróis de Arton); null for fixed-bonus races
  skill_bonuses JSON DEFAULT '[]',
  racial_abilities JSON DEFAULT '[]',
  chosen_abilities_amount INTEGER DEFAULT 0,
  available_chosen_abilities JSON DEFAULT '[]',
  longevidade TEXT, -- multiplicador de expectativa de vida (ex: "x2", "x5", "Normal"); conceito introduzido em Heróis de Arton, ausente no EJA
  devocao JSON, -- array de ids de divindades comumente devotadas por essa raça, ou null
  ability_swap JSON, -- { replaces: id, options: [ids] } — habilidade racial fixa substituível por uma de várias variantes (ex: suraggel/Deuses de Arton); null quando não há variantes
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_racas_livro ON racas(livro_id);

CREATE INDEX IF NOT EXISTS idx_racas_name ON racas(name);

CREATE TRIGGER IF NOT EXISTS update_racas_timestamp
AFTER UPDATE ON racas
BEGIN
  UPDATE racas SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- CONDIÇÕES (Status Conditions)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS condicoes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  effects JSON DEFAULT '[]',
  condition_type TEXT,
  escalates_to TEXT,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_condicoes_livro ON condicoes(livro_id);

CREATE INDEX IF NOT EXISTS idx_condicoes_name ON condicoes(name);
CREATE INDEX IF NOT EXISTS idx_condicoes_type ON condicoes(condition_type);

CREATE TRIGGER IF NOT EXISTS update_condicoes_timestamp
AFTER UPDATE ON condicoes
BEGIN
  UPDATE condicoes SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- LIVROS (Books) — fonte bibliográfica dos dados
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS livros (
  id        TEXT PRIMARY KEY,   -- slug do livro, ex: "t20_eja"
  nome      TEXT NOT NULL,      -- nome completo
  nome_curto TEXT NOT NULL,     -- abreviação exibida, ex: "T20 - EJA"
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER IF NOT EXISTS update_livros_timestamp
AFTER UPDATE ON livros
BEGIN
  UPDATE livros SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- INDICE_REMISSIVO — entradas do índice remissivo dos livros
-- Cada linha é um termo do índice associado a uma página.
-- Os campos `tabela` e `registro_id` são preenchidos quando o termo é
-- associado a um registro de outra tabela (ex: classes, poderes, magias…).
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS indice_remissivo (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  livro_id    TEXT    NOT NULL REFERENCES livros(id),
  termo       TEXT    NOT NULL,  -- termo exatamente como aparece no índice
  pagina      INTEGER NOT NULL,  -- número da página
  tabela      TEXT,              -- tabela associada (ex: "classes", "poderes")
  registro_id TEXT,              -- id do registro associado (ex: "guerreiro")
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_indice_termo    ON indice_remissivo(termo);
CREATE INDEX IF NOT EXISTS idx_indice_livro    ON indice_remissivo(livro_id);
CREATE INDEX IF NOT EXISTS idx_indice_registro ON indice_remissivo(tabela, registro_id);

CREATE TRIGGER IF NOT EXISTS update_indice_remissivo_timestamp
AFTER UPDATE ON indice_remissivo
BEGIN
  UPDATE indice_remissivo SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS MÁGICOS - POÇÕES (Potions, Oils and Grenades)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pocoes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  subtipo TEXT NOT NULL,
  spell_id TEXT NOT NULL,
  pm_cost INTEGER NOT NULL,
  categoria TEXT NOT NULL,
  preco INTEGER,
  roll_min INTEGER,
  roll_max INTEGER,
  aprimoramento TEXT,
  description TEXT,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_pocoes_livro ON pocoes(livro_id);

CREATE INDEX IF NOT EXISTS idx_pocoes_categoria ON pocoes(categoria);
CREATE INDEX IF NOT EXISTS idx_pocoes_subtipo ON pocoes(subtipo);

CREATE TRIGGER IF NOT EXISTS update_pocoes_timestamp
AFTER UPDATE ON pocoes
BEGIN
  UPDATE pocoes SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS MÁGICOS - ESOTÉRICOS (Caster Implements: staffs, wands, holy symbols)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS esotericos_magicos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  categoria TEXT NOT NULL, -- 'menor' | 'medio' | 'maior'
  preco INTEGER,
  roll_min INTEGER,
  roll_max INTEGER,
  description TEXT,
  effects JSON DEFAULT '[]', -- array of typed mechanical effect objects
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_esotericos_magicos_livro ON esotericos_magicos(livro_id);

CREATE INDEX IF NOT EXISTS idx_esotericos_magicos_categoria ON esotericos_magicos(categoria);

CREATE TRIGGER IF NOT EXISTS update_esotericos_magicos_timestamp
AFTER UPDATE ON esotericos_magicos
BEGIN
  UPDATE esotericos_magicos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS MÁGICOS - ACESSÓRIOS (Amulets, Rings, Cloaks, etc.)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS acessorios_magicos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  categoria TEXT NOT NULL,
  preco INTEGER,
  roll_min INTEGER,
  roll_max INTEGER,
  description TEXT,
  effects JSON DEFAULT '[]', -- array of typed mechanical effect objects
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_acessorios_magicos_livro ON acessorios_magicos(livro_id);

CREATE INDEX IF NOT EXISTS idx_acessorios_magicos_categoria ON acessorios_magicos(categoria);

CREATE TRIGGER IF NOT EXISTS update_acessorios_magicos_timestamp
AFTER UPDATE ON acessorios_magicos
BEGIN
  UPDATE acessorios_magicos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- PERÍCIAS (Skills)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pericias (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  atributo TEXT NOT NULL CHECK(atributo IN ('FOR', 'DES', 'CON', 'INT', 'SAB', 'CAR')),
  trained_only INTEGER NOT NULL DEFAULT 0,
  armor_penalty INTEGER NOT NULL DEFAULT 0,
  resistance_skill INTEGER NOT NULL DEFAULT 0,
  description TEXT,
  uses JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_pericias_livro ON pericias(livro_id);

CREATE INDEX IF NOT EXISTS idx_pericias_atributo ON pericias(atributo);
CREATE INDEX IF NOT EXISTS idx_pericias_trained_only ON pericias(trained_only);

CREATE TRIGGER IF NOT EXISTS update_pericias_timestamp
AFTER UPDATE ON pericias
BEGIN
  UPDATE pericias SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- TABELAS (Reference Tables)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabelas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  headers JSON NOT NULL DEFAULT '[]',
  rows JSON NOT NULL DEFAULT '[]',
  dice TEXT, -- ex: "1d100", "1d20"; se presente, a 1ª coluna de cada row é uma faixa (ex: "01-05") e a tabela é sorteável via #roll
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tabelas_livro ON tabelas(livro_id);

CREATE INDEX IF NOT EXISTS idx_tabelas_name ON tabelas(name);

CREATE TRIGGER IF NOT EXISTS update_tabelas_timestamp
AFTER UPDATE ON tabelas
BEGIN
  UPDATE tabelas SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- CRIATURAS (Monsters & Enemies)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ameacas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  nd REAL NOT NULL,
  tipo TEXT,
  subtipo TEXT,
  tamanho TEXT NOT NULL DEFAULT 'médio',
  grupo TEXT NOT NULL,
  pv INTEGER,
  defesa INTEGER,
  for INTEGER, des INTEGER, con INTEGER, int INTEGER, sab INTEGER, car INTEGER,
  iniciativa INTEGER,
  deslocamento TEXT,
  salvaguardas JSON DEFAULT '{}',
  percepcao INTEGER,
  visao TEXT,
  ataques JSON DEFAULT '[]',
  poderes_especiais JSON DEFAULT '[]',
  imunidades JSON DEFAULT '[]',
  resistencias JSON DEFAULT '{}',
  vulnerabilidades JSON DEFAULT '[]',
  reducao_de_dano JSON, -- inteiro (ex: 10) ou string com exceção (ex: "10/luz")
  cura_acelerada JSON, -- inteiro (ex: 10) ou string com exceção (ex: "100/kaiju")
  resistencia_a_magia INTEGER,
  pericias JSON DEFAULT '{}',
  equipamento JSON DEFAULT '[]',
  tesouro TEXT,
  pm INTEGER,
  familiar JSON, -- benefício simples como familiar de conjurador (texto livre), ou null
  parceiro JSON, -- benefícios de parceiro especial, por patamar: {tipo, restricao, iniciante, veterano, mestre}
  description TEXT,
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ameacas_livro ON ameacas(livro_id);

CREATE INDEX IF NOT EXISTS idx_ameacas_nd ON ameacas(nd);
CREATE INDEX IF NOT EXISTS idx_ameacas_grupo ON ameacas(grupo);
CREATE INDEX IF NOT EXISTS idx_ameacas_name ON ameacas(name);

CREATE TRIGGER IF NOT EXISTS update_ameacas_timestamp
AFTER UPDATE ON ameacas
BEGIN
  UPDATE ameacas SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS MÁGICOS - ARMAS ESPECÍFICAS (Named Magic Weapons)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS armas_magicas_especificas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  base_weapon TEXT,
  preco INTEGER,
  description TEXT,
  effects JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_armas_magicas_especificas_livro ON armas_magicas_especificas(livro_id);

CREATE INDEX IF NOT EXISTS idx_armas_magicas_name ON armas_magicas_especificas(name);

CREATE TRIGGER IF NOT EXISTS update_armas_magicas_especificas_timestamp
AFTER UPDATE ON armas_magicas_especificas
BEGIN
  UPDATE armas_magicas_especificas SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS MÁGICOS - ARMADURAS ESPECÍFICAS (Named Magic Armors & Shields)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS armaduras_magicas_especificas (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  subtipo TEXT NOT NULL DEFAULT 'armadura',
  base_item TEXT,
  preco INTEGER,
  description TEXT,
  effects JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_armaduras_magicas_especificas_livro ON armaduras_magicas_especificas(livro_id);

CREATE INDEX IF NOT EXISTS idx_armaduras_magicas_name ON armaduras_magicas_especificas(name);
CREATE INDEX IF NOT EXISTS idx_armaduras_magicas_subtipo ON armaduras_magicas_especificas(subtipo);

CREATE TRIGGER IF NOT EXISTS update_armaduras_magicas_especificas_timestamp
AFTER UPDATE ON armaduras_magicas_especificas
BEGIN
  UPDATE armaduras_magicas_especificas SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ITENS LITÚRGICOS (Liturgical Items) — Deuses de Arton
-- Itens mágicos ligados a uma divindade específica: ficam mais fortes (ou só
-- funcionam) nas mãos de devotos dessa divindade. Podem ser armas, armaduras
-- ou acessórios — por isso usam `deities` (array) em vez de FK rígida.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS itens_liturgicos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  deities JSON DEFAULT '[]',
  subtipo TEXT, -- 'arma' | 'armadura' | 'acessorio'
  base_item TEXT,
  classificacao TEXT, -- ex.: "Arma específica menor", "Acessório maior"
  preco INTEGER,
  description TEXT,
  effects JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_itens_liturgicos_livro ON itens_liturgicos(livro_id);

CREATE INDEX IF NOT EXISTS idx_itens_liturgicos_name ON itens_liturgicos(name);
CREATE INDEX IF NOT EXISTS idx_itens_liturgicos_subtipo ON itens_liturgicos(subtipo);

CREATE TRIGGER IF NOT EXISTS update_itens_liturgicos_timestamp
AFTER UPDATE ON itens_liturgicos
BEGIN
  UPDATE itens_liturgicos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- ARTEFATOS (Artifacts)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS artefatos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  effects JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_artefatos_livro ON artefatos(livro_id);

CREATE INDEX IF NOT EXISTS idx_artefatos_name ON artefatos(name);

CREATE TRIGGER IF NOT EXISTS update_artefatos_timestamp
AFTER UPDATE ON artefatos
BEGIN
  UPDATE artefatos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- DISTINÇÕES (Distinctions) — Heróis de Arton / Deuses de Arton
-- Cada distinção tem admissão (requisito narrativo), marca (habilidade
-- automática) e uma árvore de poderes exclusivos. Os poderes de fato ficam
-- na tabela `poderes` (type = 'poder_distincao', distincao_id aponta aqui).
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS distincoes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,           -- resumo curto
  admissao TEXT,               -- requisitos narrativos de admissão
  marca_nome TEXT,             -- nome da "Marca da Distinção"
  marca_descricao TEXT,        -- efeito da marca (concedida automaticamente na admissão)
  nivel_minimo INTEGER DEFAULT 5, -- nível mínimo para obter poderes da distinção (veterano)
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_distincoes_livro ON distincoes(livro_id);
CREATE INDEX IF NOT EXISTS idx_distincoes_name ON distincoes(name);

-- -----------------------------------------------------------------------------
-- COMPLICAÇÕES (Character Complications — Heróis de Arton, Cap. 4)
-- -----------------------------------------------------------------------------
-- Desvantagens escolhidas na criação de personagem: concedem uma penalidade
-- mecânica em troca de um poder geral gratuito.
CREATE TABLE IF NOT EXISTS complicacoes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  categoria TEXT NOT NULL DEFAULT 'geral', -- 'geral' ou id de classe (ex: 'guerreiro') p/ complicações específicas de classe
  effects JSON DEFAULT '[]',   -- penalidades mecânicas tipadas
  -- Sem coluna de "poder concedido": a regra do livro é escolha livre de QUALQUER poder geral
  -- cujos pré-requisitos sejam cumpridos, não um poder fixo por complicação (confirmado no texto:
  -- "Você é livre para escolher o poder, mas deve preencher seus pré-requisitos").
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_complicacoes_livro ON complicacoes(livro_id);
CREATE INDEX IF NOT EXISTS idx_complicacoes_categoria ON complicacoes(categoria);

CREATE TRIGGER IF NOT EXISTS update_distincoes_timestamp
AFTER UPDATE ON distincoes
BEGIN
  UPDATE distincoes SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- BASES (Group Headquarters — Heróis de Arton, Cap. 3)
-- -----------------------------------------------------------------------------
-- Só o conteúdo de referência/catálogo (tipos, cômodos, mobílias) mora na gem — a
-- instância real de uma base específica de um grupo (tipo+porte+cômodos escolhidos)
-- é estado de campanha, não dado da gem, e vive no consumidor (arkheion_api).
-- A escala de porte (Tabela 3-6: custo/manutenção/cômodos por porte) é modelada
-- como uma entrada comum em `tabelas`, não uma tabela própria.

CREATE TABLE IF NOT EXISTS bases_tipos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  effects JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_bases_tipos_livro ON bases_tipos(livro_id);

CREATE TRIGGER IF NOT EXISTS update_bases_tipos_timestamp
AFTER UPDATE ON bases_tipos
BEGIN
  UPDATE bases_tipos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TABLE IF NOT EXISTS comodos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  effects JSON DEFAULT '[]',
  prerequisito TEXT, -- texto livre (ex: "base formidável ou melhor") ou id de outro cômodo pré-requisito
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_comodos_livro ON comodos(livro_id);

CREATE TRIGGER IF NOT EXISTS update_comodos_timestamp
AFTER UPDATE ON comodos
BEGIN
  UPDATE comodos SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TABLE IF NOT EXISTS mobilias (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  effects JSON DEFAULT '[]',
  preco INTEGER,
  comodo_alvo TEXT, -- id do cômodo onde deve ser instalada, se restrita (ex: banheira -> suite); null = qualquer cômodo
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_mobilias_livro ON mobilias(livro_id);

CREATE TRIGGER IF NOT EXISTS update_mobilias_timestamp
AFTER UPDATE ON mobilias
BEGIN
  UPDATE mobilias SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- CONSTRUÇÕES DE DOMÍNIO (Domain Buildings — Heróis de Arton, Cap. 4 "Domínios")
-- -----------------------------------------------------------------------------
-- Só o catálogo de construções mora na gem (mesmo princípio de bases_tipos/comodos/
-- mobilias) — o domínio real de um regente específico (nível, corte, popularidade,
-- construções erguidas) é estado de campanha, não dado da gem. Terrenos (Tabela 4-9)
-- viram uma entrada comum em `tabelas`; corte/popularidade/fortificação (poucas
-- categorias fixas) ficam no `data` de `regras/dominios.json` em vez de tabelas próprias.
CREATE TABLE IF NOT EXISTS construcoes_dominio (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  categoria TEXT NOT NULL, -- 'nobreza' | 'guerra' | 'enganacao' | 'religiao' | 'misticismo'
  custo INTEGER, -- custo em Lingotes de Ouro (LO)
  effects JSON DEFAULT '[]',
  prerequisito TEXT, -- texto livre ou id de outra construção/terreno pré-requisito
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_construcoes_dominio_livro ON construcoes_dominio(livro_id);
CREATE INDEX IF NOT EXISTS idx_construcoes_dominio_categoria ON construcoes_dominio(categoria);

CREATE TRIGGER IF NOT EXISTS update_construcoes_dominio_timestamp
AFTER UPDATE ON construcoes_dominio
BEGIN
  UPDATE construcoes_dominio SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- -----------------------------------------------------------------------------
-- CLASSES VARIANTES (Variant Classes) — Heróis de Arton
-- Representadas como diff sobre a classe-base: `diffs` é um array de
-- { nivel, remove: [habilidade_ids], adiciona: [{...habilidade}] }.
-- Consumidores devem aplicar o diff sobre `classes.powers`/`abilities` da
-- classe-base para montar a ficha final.
-- NB: coluna chama-se `diffs`, não `changes` — `changes` é reservado pelo
-- ActiveRecord (dirty tracking) e quebraria o modelo Ruby.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS classes_variantes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  base_class_id TEXT NOT NULL REFERENCES classes(id),
  description TEXT,
  diffs JSON DEFAULT '[]',
  livro_id TEXT NOT NULL DEFAULT 't20_eja' REFERENCES livros(id),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_classes_variantes_livro ON classes_variantes(livro_id);
CREATE INDEX IF NOT EXISTS idx_classes_variantes_base ON classes_variantes(base_class_id);

CREATE TRIGGER IF NOT EXISTS update_classes_variantes_timestamp
AFTER UPDATE ON classes_variantes
BEGIN
  UPDATE classes_variantes SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- =============================================================================
-- VIEWS ÚTEIS
-- =============================================================================

-- View de resumo de magias
CREATE VIEW IF NOT EXISTS magias_summary AS
SELECT
  id,
  name,
  type,
  circle,
  school,
  execution,
  range,
  duration
FROM magias;

-- View de poderes por tipo
CREATE VIEW IF NOT EXISTS poderes_por_tipo AS
SELECT
  type,
  COUNT(*) as total,
  GROUP_CONCAT(name, ', ') as nomes
FROM poderes
GROUP BY type;

-- View de divindades com contagem de poderes
CREATE VIEW IF NOT EXISTS divindades_resumo AS
SELECT
  d.id,
  d.name,
  d.title,
  d.energy,
  json_array_length(d.granted_powers) as total_poderes
FROM divindades d;
