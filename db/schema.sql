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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
    'poder_geral',
    'poder_combate',
    'poder_destino',
    'poder_magia'
  )),
  description TEXT,
  effects JSON DEFAULT '{}',
  prerequisites JSON DEFAULT '[]',
  origin_id TEXT,
  deities JSON DEFAULT '[]',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_poderes_type ON poderes(type);
CREATE INDEX IF NOT EXISTS idx_poderes_name ON poderes(name);
CREATE INDEX IF NOT EXISTS idx_poderes_origin ON poderes(origin_id);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_materiais_especiais_name ON materiais_especiais(name);

CREATE TRIGGER IF NOT EXISTS update_materiais_especiais_timestamp
AFTER UPDATE ON materiais_especiais
BEGIN
  UPDATE materiais_especiais SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
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
  effects JSON DEFAULT '{}',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

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
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_regras_name ON regras(name);

CREATE TRIGGER IF NOT EXISTS update_regras_timestamp
AFTER UPDATE ON regras
BEGIN
  UPDATE regras SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
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
