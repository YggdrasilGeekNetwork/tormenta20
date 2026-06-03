import Database from "better-sqlite3"
import { readdirSync, readFileSync, statSync } from "fs"
import { join, dirname, basename } from "path"
import { fileURLToPath } from "url"

const __dirname = dirname(fileURLToPath(import.meta.url))
const JSON_DIR = join(__dirname, "../../src/json")
const DB_PATH = process.env.TORMENTA20_DB_PATH ?? join(__dirname, "../../db/tormenta20.sqlite3")
const SCHEMA_PATH = join(__dirname, "../../db/schema.sql")

function readJson<T>(path: string): T {
  return JSON.parse(readFileSync(path, "utf-8")) as T
}

function loadJsonFiles<T>(dir: string): T[] {
  const results: T[] = []
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) {
      results.push(...loadJsonFiles<T>(full))
    } else if (entry.endsWith(".json")) {
      const parsed = readJson<T>(full)
      if (parsed && typeof parsed === "object" && "id" in (parsed as object) && (parsed as Record<string, unknown>).id !== "") {
        results.push(parsed)
      }
    }
  }
  return results
}

function loadJsonDir<T>(dir: string): T[] {
  return readdirSync(dir)
    .filter((f) => f.endsWith(".json"))
    .map((f) => readJson<T>(join(dir, f)))
    .filter((p) => (p as Record<string, unknown>).id !== "")
}

export function seed(): void {
  const db = new Database(DB_PATH)
  db.pragma("journal_mode = WAL")
  db.pragma("foreign_keys = OFF")

  const schema = readFileSync(SCHEMA_PATH, "utf-8")
  db.exec(schema)

  const insert = db.transaction((table: string, rows: Record<string, unknown>[]) => {
    if (rows.length === 0) return
    const keys = Object.keys(rows[0])
    const cols = keys.join(", ")
    const vals = keys.map(() => "?").join(", ")
    const stmt = db.prepare(`INSERT OR REPLACE INTO ${table} (${cols}) VALUES (${vals})`)
    for (const row of rows) stmt.run(...keys.map((k) => {
      const v = row[k]
      return typeof v === "object" && v !== null ? JSON.stringify(v) : v
    }))
  })

  seedRacas(insert)
  seedOrigens(insert)
  seedDivindades(insert)
  seedClasses(insert)
  seedPoderes(insert)
  seedMagias(insert)
  seedEquipamentos(insert)
  seedItensSuperiores(insert)
  seedCondicoes(insert)
  seedPericias(insert)
  seedRegras(insert)

  db.pragma("foreign_keys = ON")
  db.close()
  console.log("✓ Tormenta 20 database seeded successfully")
}

function seedRacas(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const racas = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "racas"))
  insert("racas", racas)
}

function seedOrigens(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const origens = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "origens"))
  insert("origens", origens.map((o) => ({
    id: o.id, name: o.name, description: o.description ?? null,
    items: o.items ?? [], benefits: o.benefits ?? {}, unique_power: o.unique_power ?? null,
  })))
}

function seedDivindades(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const divs = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "deuses"))
  insert("divindades", divs.map((d) => ({
    id: d.id, name: d.name, title: d.title ?? null, description: d.description ?? null,
    beliefs_objectives: d.beliefs_objectives ?? [], holy_symbol: d.holy_symbol ?? null,
    energy: d.energy ?? "qualquer", preferred_weapon: d.preferred_weapon ?? null,
    devotees: d.devotees ?? {}, granted_powers: d.granted_powers ?? [],
    obligations_restrictions: d.obligations_restrictions ?? null,
  })))
}

function seedClasses(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const classes = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "classes"))
  insert("classes", classes.map((c) => ({
    id: c.id, name: c.name,
    hit_points: c.hit_points ?? {}, mana_points: c.mana_points ?? {},
    skills: c.skills ?? {}, proficiencies: c.proficiencies ?? {},
    abilities: c.abilities ?? [], powers: c.powers ?? [],
    progression: c.progression ?? [],
    spellcasting: c.spellcasting && Object.keys(c.spellcasting as object).length > 0 ? c.spellcasting : null,
  })))
}

const PODER_DIR_TYPE_MAP: Record<string, string> = {
  habilidades_de_raca: "habilidade_de_raca",
  habilidades_unicas_de_origem: "habilidade_unica_origem",
  poderes_concedidos: "poder_concedido",
  poderes_da_tormenta: "poder_tormenta",
  poderes_de_combate: "poder_combate",
  poderes_de_destino: "poder_destino",
  poderes_de_magia: "poder_magia",
}

function seedPoderes(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const poderesDir = join(JSON_DIR, "poderes")
  const rows: Record<string, unknown>[] = []

  for (const topDir of readdirSync(poderesDir)) {
    const topPath = join(poderesDir, topDir)
    if (!statSync(topPath).isDirectory()) continue

    if (topDir === "poderes_gerais") {
      for (const subDir of readdirSync(topPath)) {
        const subPath = join(topPath, subDir)
        if (!statSync(subPath).isDirectory()) continue
        const type = PODER_DIR_TYPE_MAP[subDir] ?? "poder_geral"
        const files = loadJsonFiles<Record<string, unknown>>(subPath)
        rows.push(...files.map((p) => mapPoder(p, type, null, null)))
      }
      continue
    }

    if (topDir === "habilidades_de_classe") {
      for (const classDir of readdirSync(topPath)) {
        const classPath = join(topPath, classDir)
        if (!statSync(classPath).isDirectory()) continue
        const files = loadJsonDir<Record<string, unknown>>(classPath)
        rows.push(...files.map((p) => mapPoder(p, "poder_classe", null, classDir)))
      }
      continue
    }

    const type = PODER_DIR_TYPE_MAP[topDir] ?? "poder_geral"

    if (topDir === "habilidades_de_raca") {
      for (const subDir of readdirSync(topPath)) {
        const subPath = join(topPath, subDir)
        if (statSync(subPath).isDirectory()) {
          const files = loadJsonDir<Record<string, unknown>>(subPath)
          rows.push(...files.map((p) => mapPoder(p, type, null, null)))
        } else if (subDir.endsWith(".json")) {
          const p = readJson<Record<string, unknown>>(subPath)
          if ((p.id as string) !== "") rows.push(mapPoder(p, type, null, null))
        }
      }
      continue
    }

    if (topDir === "habilidades_unicas_de_origem") {
      const files = loadJsonDir<Record<string, unknown>>(topPath)
      rows.push(...files.map((p) => mapPoder(p, type, (p.origin as string) ?? null, null)))
      continue
    }

    const files = loadJsonFiles<Record<string, unknown>>(topPath)
    rows.push(...files.map((p) => mapPoder(p, type, null, null)))
  }

  insert("poderes", rows)
}

function mapPoder(p: Record<string, unknown>, type: string, originId: string | null, classId: string | null): Record<string, unknown> {
  return {
    id: p.id, name: p.name, type,
    description: p.description ?? null,
    effects: p.effects ?? [], costs: p.costs ?? [],
    prerequisites: p.requirements ?? p.prerequisites ?? [],
    origin_id: originId, class_id: classId,
    deities: p.deities ?? [],
  }
}

function seedMagias(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const magias = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "magias"))
  insert("magias", magias.map((m) => {
    const target = Array.isArray(m.target) ? m.target[0] : (m.target as Record<string, unknown> | null)
    return {
      id: m.id, name: m.name, type: m.type, circle: m.circle, school: m.school,
      execution: m.execution, execution_details: m.execution_details ?? null,
      range: m.range, duration: m.duration, duration_details: m.duration_details ?? null,
      counterspell: m.counterspell ?? null, description: m.description,
      target_amount: target?.amount ?? null,
      target_up_to: target?.up_to ? 1 : 0,
      target_type: target?.type ?? null,
      effect: m.effect ?? null, effect_shape: null, effect_dimention: null,
      effect_size: null, effect_other_details: m.effect_details ?? null,
      area_effect: null, area_effect_details: null,
      resistence_effect: (m.resistence as Record<string, unknown>)?.effect ?? null,
      resistence_skill: (m.resistence as Record<string, unknown>)?.skill ?? null,
      extra_costs_material_component: null, extra_costs_material_cost: null,
      extra_costs_pm_debuff: null, extra_costs_pm_sacrifice: null,
      enhancements: m.enhancements ?? [], effects: m.effects ?? [],
    }
  }))
}

const ARMA_CATEGORY_MAP: Record<string, string> = {
  simples: "simples",
  marcial: "marciais",
  exotica: "exoticas",
  fogo: "fogo",
}

function seedEquipamentos(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const eqDir = join(JSON_DIR, "equipamentos")

  const armas = loadJsonFiles<Record<string, unknown>>(join(eqDir, "armas"))
  insert("armas", armas.map((a) => ({
    id: a.id, name: a.name,
    category: ARMA_CATEGORY_MAP[a.proficiencia as string] ?? a.proficiencia,
    price: a.preco ?? 0,
    damage: a.dano ?? null,
    damage_type: a.tipo_dano ?? null,
    critical: a.critico ?? null,
    range: a.alcance === "corpo_a_corpo" || !a.alcance ? null : a.alcance,
    weight: a.espacos ?? 0,
    properties: a.habilidades ?? [],
    description: a.description ?? null,
  })))

  const armaduras = loadJsonFiles<Record<string, unknown>>(join(eqDir, "armaduras"))
  insert("armaduras", armaduras.map((a) => ({
    id: a.id, name: a.name, category: a.categoria ?? a.category,
    price: a.preco ?? a.price ?? 0,
    defense_bonus: a.bonus_defesa ?? a.defense_bonus ?? 0,
    armor_penalty: a.penalidade ?? a.armor_penalty ?? 0,
    weight: a.espacos ?? a.weight ?? 0,
    properties: a.habilidades ?? a.properties ?? [],
    description: a.description ?? null,
  })))

  const escudos = loadJsonFiles<Record<string, unknown>>(join(eqDir, "escudos"))
  insert("escudos", escudos.map((e) => ({
    id: e.id, name: e.name,
    price: e.preco ?? e.price ?? 0,
    defense_bonus: e.bonus_defesa ?? e.defense_bonus ?? 0,
    armor_penalty: e.penalidade ?? e.armor_penalty ?? 0,
    weight: e.espacos ?? e.weight ?? 0,
    properties: e.habilidades ?? e.properties ?? [],
    description: e.description ?? null,
  })))

  const itens = loadJsonFiles<Record<string, unknown>>(join(eqDir, "itens"))
  insert("itens", itens.map((i) => ({
    id: i.id, name: i.name, category: i.category ?? null,
    price: i.preco ?? i.price ?? 0,
    weight: i.espacos ?? i.weight ?? 0,
    description: i.description ?? null,
    effects: i.effects ?? {},
  })))
}

function seedItensSuperiores(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const dir = join(JSON_DIR, "itens_superiores")

  const materiais = loadJsonDir<Record<string, unknown>>(join(dir, "materiais_especiais"))
  insert("materiais_especiais", materiais.map((m) => ({
    id: m.id, name: m.name, description: m.description ?? null,
    applicable_to: [], price_modifier: m.precos_adicionais ?? m.price_modifier ?? {},
    effects: m.efeitos ?? m.effects ?? {},
  })))

  const melhorias = loadJsonFiles<Record<string, unknown>>(join(dir, "melhorias"))
  insert("melhorias", melhorias.map((m) => ({
    id: m.id, name: m.name, description: m.description ?? null,
    applicable_to: m.applicable_to ?? [], price: m.price ?? 0,
    effects: m.effects ?? {},
  })))

  const encantamentos = loadJsonFiles<Record<string, unknown>>(join(dir, "encantamentos"))
  insert("encantamentos", encantamentos.map((e) => ({
    id: e.id, name: e.name, description: e.description ?? null,
    categoria: e.categoria ?? "arma",
    escudo_only: e.escudo_only ? 1 : 0,
    conta_como_dois: e.conta_como_dois ? 1 : 0,
    prerequisitos: e.prerequisitos ?? [],
    efeito: e.efeito ?? {},
  })))
}

function seedCondicoes(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const condicoes = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "condicoes"))
  insert("condicoes", condicoes.map((c) => ({
    id: c.id, name: c.name, description: c.description ?? null,
    effects: c.effects ?? [], condition_type: c.condition_type ?? c.tipo ?? null,
    escalates_to: c.escalates_to ?? null,
  })))
}

function seedPericias(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const pericias = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "pericias"))
  insert("pericias", pericias.map((p) => ({
    id: p.id, name: p.name, atributo: p.atributo,
    trained_only: p.trained_only ? 1 : 0,
    armor_penalty: p.armor_penalty ? 1 : 0,
    resistance_skill: p.resistance_skill ? 1 : 0,
    description: p.description ?? null, uses: p.uses ?? [],
  })))
}

function seedRegras(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "regras"))) return
  const regras = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "regras"))
  insert("regras", regras.map((r) => {
    const { id, name, description, ...rest } = r
    return { id, name, description: description ?? null, data: rest }
  }))
}

function existsDir(path: string): boolean {
  try { return statSync(path).isDirectory() } catch { return false }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  seed()
}
