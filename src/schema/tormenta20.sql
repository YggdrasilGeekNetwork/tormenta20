-- =============================================================================
-- TORMENTA 20 DATABASE SCHEMA
-- =============================================================================
-- Este schema suporta todos os tipos de dados do sistema Tormenta 20
-- Usa PostgreSQL com JSONB para campos flexíveis de efeitos mecânicos
-- =============================================================================

-- Extensão para UUIDs (opcional, caso queira usar UUIDs como PK)
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- TABELAS PRINCIPAIS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- ORIGENS (Character Origins)
-- -----------------------------------------------------------------------------
CREATE TABLE origens (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    items JSONB DEFAULT '[]',           -- Array de strings com itens iniciais
    benefits JSONB DEFAULT '{}',         -- { skills: [], powers: [] }
    unique_power VARCHAR(100),           -- Referência ao poder único
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE origens IS 'Origens de personagem (backgrounds)';
COMMENT ON COLUMN origens.items IS 'Itens iniciais da origem';
COMMENT ON COLUMN origens.benefits IS 'Benefícios: perícias e poderes disponíveis';
COMMENT ON COLUMN origens.unique_power IS 'ID do poder único da origem';

-- -----------------------------------------------------------------------------
-- PODERES (Powers) - Tabela unificada para todos os tipos de poderes
-- -----------------------------------------------------------------------------
CREATE TYPE power_type AS ENUM (
    'habilidade_unica_origem',  -- Habilidades únicas de origem
    'poder_concedido',          -- Poderes concedidos por divindades
    'poder_tormenta',           -- Poderes da Tormenta
    'poder_classe',             -- Poderes de classe
    'poder_geral',              -- Poderes gerais
    'poder_combate',            -- Poderes de combate
    'poder_destino',            -- Poderes de destino
    'poder_magia'               -- Poderes de magia
);

CREATE TABLE poderes (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type power_type NOT NULL,
    description TEXT,
    effects JSONB DEFAULT '{}',          -- Efeitos mecânicos estruturados
    prerequisites JSONB DEFAULT '[]',    -- Pré-requisitos
    origin_id VARCHAR(100),              -- Para habilidades únicas de origem
    deities JSONB DEFAULT '[]',          -- Para poderes concedidos (array de deity IDs)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_poderes_type ON poderes(type);
CREATE INDEX idx_poderes_origin ON poderes(origin_id) WHERE origin_id IS NOT NULL;
CREATE INDEX idx_poderes_deities ON poderes USING GIN(deities) WHERE deities != '[]';

COMMENT ON TABLE poderes IS 'Todos os tipos de poderes do sistema';
COMMENT ON COLUMN poderes.effects IS 'Efeitos mecânicos em formato JSON estruturado';
COMMENT ON COLUMN poderes.deities IS 'Array de IDs de divindades que concedem o poder';

-- -----------------------------------------------------------------------------
-- DIVINDADES (Deities)
-- -----------------------------------------------------------------------------
CREATE TYPE energy_type AS ENUM ('positiva', 'negativa', 'qualquer');

CREATE TABLE divindades (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    title VARCHAR(255),                  -- Ex: "Deus da Justiça"
    description TEXT,
    beliefs_objectives JSONB DEFAULT '[]', -- Array de strings
    holy_symbol VARCHAR(255),
    energy energy_type NOT NULL DEFAULT 'qualquer',
    preferred_weapon VARCHAR(255),
    devotees JSONB DEFAULT '{}',         -- { races: [], classes: [] }
    granted_powers JSONB DEFAULT '[]',   -- Array de power IDs
    obligations_restrictions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE divindades IS 'Deuses do Panteão de Arton';
COMMENT ON COLUMN divindades.devotees IS 'Raças e classes que podem ser devotos';
COMMENT ON COLUMN divindades.granted_powers IS 'IDs dos poderes concedidos';

-- -----------------------------------------------------------------------------
-- CLASSES (Character Classes)
-- -----------------------------------------------------------------------------
CREATE TABLE classes (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    hit_points JSONB NOT NULL,           -- { initial: int, per_level: int }
    mana_points JSONB NOT NULL,          -- { per_level: int }
    skills JSONB NOT NULL,               -- { mandatory: [], choose_amount: int, choose_from: [] }
    proficiencies JSONB NOT NULL,        -- { weapons: [], armors: [], shields: bool }
    abilities JSONB DEFAULT '[]',        -- Array de ability IDs
    powers JSONB DEFAULT '[]',           -- Array de power IDs disponíveis
    progression JSONB DEFAULT '[]',      -- Array de { level: int, abilities: [] }
    spellcasting JSONB,                  -- Configuração de magia (se aplicável)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE classes IS 'Classes de personagem';
COMMENT ON COLUMN classes.progression IS 'Progressão de habilidades por nível';

-- -----------------------------------------------------------------------------
-- MAGIAS (Spells)
-- -----------------------------------------------------------------------------
CREATE TYPE spell_type AS ENUM ('arcana', 'divina', 'universal');
CREATE TYPE spell_school AS ENUM ('abjur', 'adiv', 'conv', 'encan', 'evoc', 'ilusao', 'necro', 'trans');

CREATE TABLE magias (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type spell_type NOT NULL,
    circle SMALLINT NOT NULL CHECK (circle >= 1 AND circle <= 5),
    school spell_school NOT NULL,
    execution VARCHAR(50) NOT NULL,      -- padrão, completa, reação, livre
    execution_details TEXT,
    range VARCHAR(100),
    target JSONB,                        -- { amount, up_to, type }
    effect VARCHAR(50),                  -- area, alvo, etc.
    effect_details JSONB,                -- { shape, dimension, size, etc. }
    duration VARCHAR(100),
    duration_details TEXT,
    resistance JSONB,                    -- { effect, skill }
    extra_costs TEXT,
    description TEXT NOT NULL,
    enhancements JSONB DEFAULT '[]',     -- Array de aprimoramentos
    effects JSONB DEFAULT '[]',          -- Efeitos mecânicos
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_magias_type ON magias(type);
CREATE INDEX idx_magias_circle ON magias(circle);
CREATE INDEX idx_magias_school ON magias(school);

COMMENT ON TABLE magias IS 'Magias arcanas e divinas';
COMMENT ON COLUMN magias.enhancements IS 'Aprimoramentos disponíveis para a magia';

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ARMAS (Weapons)
-- -----------------------------------------------------------------------------
CREATE TYPE weapon_category AS ENUM ('simples', 'marciais', 'exoticas', 'fogo');
CREATE TYPE damage_type AS ENUM ('corte', 'perfuracao', 'impacto', 'fogo', 'frio', 'eletricidade', 'acido', 'trevas', 'luz', 'psiquico');

CREATE TABLE armas (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category weapon_category NOT NULL,
    price INTEGER,                       -- Preço em T$
    damage VARCHAR(20),                  -- Ex: "1d8", "2d6"
    damage_type damage_type,
    critical VARCHAR(20),                -- Ex: "19/x2", "x3"
    range VARCHAR(50),                   -- curto, medio, longo ou NULL
    weight DECIMAL(10,2),                -- Peso em kg
    properties JSONB DEFAULT '[]',       -- Propriedades especiais (array)
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_armas_category ON armas(category);

COMMENT ON TABLE armas IS 'Armas do sistema';

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ARMADURAS (Armors)
-- -----------------------------------------------------------------------------
CREATE TYPE armor_category AS ENUM ('leve', 'pesada');

CREATE TABLE armaduras (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category armor_category NOT NULL,
    price INTEGER,
    defense_bonus INTEGER NOT NULL,      -- Bônus de defesa
    armor_penalty INTEGER DEFAULT 0,     -- Penalidade de armadura
    weight DECIMAL(10,2),
    properties JSONB DEFAULT '[]',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE armaduras IS 'Armaduras do sistema';

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ESCUDOS (Shields)
-- -----------------------------------------------------------------------------
CREATE TABLE escudos (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price INTEGER,
    defense_bonus INTEGER NOT NULL,
    armor_penalty INTEGER DEFAULT 0,
    weight DECIMAL(10,2),
    properties JSONB DEFAULT '[]',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE escudos IS 'Escudos do sistema';

-- -----------------------------------------------------------------------------
-- EQUIPAMENTOS - ITENS GERAIS (General Items)
-- -----------------------------------------------------------------------------
CREATE TABLE itens (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),               -- Categoria do item
    price INTEGER,
    weight DECIMAL(10,2),
    description TEXT,
    effects JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE itens IS 'Itens gerais (equipamentos, ferramentas, etc.)';

-- -----------------------------------------------------------------------------
-- ITENS SUPERIORES - MATERIAIS ESPECIAIS (Special Materials)
-- -----------------------------------------------------------------------------
CREATE TABLE materiais_especiais (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    applicable_to JSONB DEFAULT '[]',    -- Tipos de itens aplicáveis
    price_modifier JSONB,                -- Modificador de preço
    effects JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE materiais_especiais IS 'Materiais especiais para itens';

-- -----------------------------------------------------------------------------
-- ITENS SUPERIORES - MELHORIAS (Enhancements)
-- -----------------------------------------------------------------------------
CREATE TABLE melhorias (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    applicable_to JSONB DEFAULT '[]',
    price INTEGER,
    effects JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE melhorias IS 'Melhorias mágicas para itens';

-- -----------------------------------------------------------------------------
-- REGRAS (Rules/Reference Data)
-- -----------------------------------------------------------------------------
CREATE TABLE regras (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    data JSONB NOT NULL,                 -- Dados estruturados da regra
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE regras IS 'Regras e dados de referência do sistema';

-- =============================================================================
-- TABELAS DE RELACIONAMENTO (Junction Tables)
-- =============================================================================

-- Relacionamento entre divindades e poderes concedidos
CREATE TABLE divindade_poderes (
    divindade_id VARCHAR(100) REFERENCES divindades(id) ON DELETE CASCADE,
    poder_id VARCHAR(100) REFERENCES poderes(id) ON DELETE CASCADE,
    PRIMARY KEY (divindade_id, poder_id)
);

-- Relacionamento entre classes e poderes disponíveis
CREATE TABLE classe_poderes (
    classe_id VARCHAR(100) REFERENCES classes(id) ON DELETE CASCADE,
    poder_id VARCHAR(100) REFERENCES poderes(id) ON DELETE CASCADE,
    PRIMARY KEY (classe_id, poder_id)
);

-- Relacionamento entre classes e magias (para classes conjuradoras)
CREATE TABLE classe_magias (
    classe_id VARCHAR(100) REFERENCES classes(id) ON DELETE CASCADE,
    magia_id VARCHAR(100) REFERENCES magias(id) ON DELETE CASCADE,
    circle_available SMALLINT,           -- Círculo em que a magia fica disponível
    PRIMARY KEY (classe_id, magia_id)
);

-- =============================================================================
-- VIEWS ÚTEIS
-- =============================================================================

-- View de poderes concedidos com suas divindades
CREATE VIEW v_poderes_concedidos AS
SELECT
    p.id,
    p.name,
    p.description,
    p.effects,
    p.prerequisites,
    ARRAY_AGG(d.name ORDER BY d.name) as divindades_nomes,
    p.deities as divindades_ids
FROM poderes p
LEFT JOIN divindades d ON d.id = ANY(
    SELECT jsonb_array_elements_text(p.deities)
)
WHERE p.type = 'poder_concedido'
GROUP BY p.id, p.name, p.description, p.effects, p.prerequisites, p.deities;

-- View de origens com seus poderes únicos
CREATE VIEW v_origens_completas AS
SELECT
    o.id,
    o.name,
    o.description,
    o.items,
    o.benefits,
    p.name as unique_power_name,
    p.description as unique_power_description,
    p.effects as unique_power_effects
FROM origens o
LEFT JOIN poderes p ON p.id = o.unique_power;

-- View de divindades com seus poderes
CREATE VIEW v_divindades_completas AS
SELECT
    d.id,
    d.name,
    d.title,
    d.description,
    d.beliefs_objectives,
    d.holy_symbol,
    d.energy,
    d.preferred_weapon,
    d.devotees,
    d.obligations_restrictions,
    ARRAY_AGG(
        jsonb_build_object(
            'id', p.id,
            'name', p.name,
            'description', p.description
        ) ORDER BY p.name
    ) FILTER (WHERE p.id IS NOT NULL) as poderes
FROM divindades d
LEFT JOIN poderes p ON p.id = ANY(
    SELECT jsonb_array_elements_text(d.granted_powers)
)
GROUP BY d.id;

-- =============================================================================
-- FUNÇÕES AUXILIARES
-- =============================================================================

-- Função para atualizar timestamp de updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualização automática de updated_at
CREATE TRIGGER update_origens_updated_at BEFORE UPDATE ON origens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_poderes_updated_at BEFORE UPDATE ON poderes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_divindades_updated_at BEFORE UPDATE ON divindades
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_classes_updated_at BEFORE UPDATE ON classes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_magias_updated_at BEFORE UPDATE ON magias
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_armas_updated_at BEFORE UPDATE ON armas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_armaduras_updated_at BEFORE UPDATE ON armaduras
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_escudos_updated_at BEFORE UPDATE ON escudos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_itens_updated_at BEFORE UPDATE ON itens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_materiais_especiais_updated_at BEFORE UPDATE ON materiais_especiais
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_melhorias_updated_at BEFORE UPDATE ON melhorias
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_regras_updated_at BEFORE UPDATE ON regras
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- ÍNDICES ADICIONAIS PARA PERFORMANCE
-- =============================================================================

-- Índices GIN para busca em campos JSONB
CREATE INDEX idx_origens_benefits ON origens USING GIN(benefits);
CREATE INDEX idx_poderes_effects ON poderes USING GIN(effects);
CREATE INDEX idx_divindades_devotees ON divindades USING GIN(devotees);
CREATE INDEX idx_magias_effects ON magias USING GIN(effects);
CREATE INDEX idx_magias_enhancements ON magias USING GIN(enhancements);

-- Índices para busca textual
CREATE INDEX idx_origens_name ON origens(name);
CREATE INDEX idx_poderes_name ON poderes(name);
CREATE INDEX idx_divindades_name ON divindades(name);
CREATE INDEX idx_classes_name ON classes(name);
CREATE INDEX idx_magias_name ON magias(name);
CREATE INDEX idx_armas_name ON armas(name);
