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
  seedClassesVariantes(insert)
  seedDistincoes(insert)
  seedComplicacoes(insert)
  seedBasesTipos(insert)
  seedComodos(insert)
  seedMobilias(insert)
  seedConstrucoesDominio(insert)
  seedRegras(insert)
  seedTabelas(insert)
  seedLivros(insert)
  seedItensmagicos(insert)
  seedArmasMagicasEspecificas(insert)
  seedArmadurasEscudosMagicos(insert)
  seedItensLiturgicos(insert)
  seedArtefatos(insert)
  seedAmeacas(insert)
  seedIndiceRemissivo()

  db.pragma("foreign_keys = ON")
  db.close()
  console.log("✓ Tormenta 20 database seeded successfully")
}

function livroIdOf(x: Record<string, unknown>): string {
  return (x.livro as string | undefined) ?? "t20_eja"
}

// insert() only serializes objects; JSON columns that may hold a bare string or number need explicit encoding.
function jsonOrNull(v: unknown): string | null {
  return v === undefined || v === null ? null : JSON.stringify(v)
}

function isPlainObject(v: unknown): v is Record<string, unknown> {
  return typeof v === "object" && v !== null && !Array.isArray(v)
}

function seedRacas(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const racas = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "racas"))
  insert("racas", racas.map((r) => ({
    id: r.id, name: r.name, description: r.description ?? null,
    size: r.size ?? "médio", movement: r.movement ?? 9,
    vision: r.vision ?? "normal", vision_range: r.vision_range ?? null,
    attribute_bonuses: r.attribute_bonuses ?? {},
    chosen_attribute_bonus: r.chosen_attribute_bonus ?? null,
    skill_bonuses: r.skill_bonuses ?? [],
    racial_abilities: r.racial_abilities ?? [],
    chosen_abilities_amount: r.chosen_abilities_amount ?? 0,
    available_chosen_abilities: r.available_chosen_abilities ?? [],
    longevidade: r.longevidade ?? null, devocao: r.devocao ?? null,
    ability_swap: r.ability_swap ?? null,
    livro_id: livroIdOf(r),
  })))
}

function seedOrigens(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const origens = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "origens"))
  insert("origens", origens.map((o) => ({
    id: o.id, name: o.name, description: o.description ?? null,
    items: o.items ?? [], benefits: o.benefits ?? {}, unique_power: o.unique_power ?? null,
    livro_id: livroIdOf(o),
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
    rank: d.rank ?? "maior", natureza: d.natureza ?? null,
    status_divino: d.status_divino ?? null,
    livro_id: livroIdOf(d),
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
    livro_id: livroIdOf(c),
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

// Within poderes_gerais/, a file's own sub_type/type (not its subdirectory) decides
// its final type, mirroring Ruby's PODER_GERAL_TYPE_MAP — unmapped values (e.g.
// poder_de_grupo, poder_de_raca) pass through unchanged.
const PODER_GERAL_TYPE_MAP: Record<string, string> = {
  poder_de_combate: "poder_combate",
  poder_de_destino: "poder_destino",
  poder_de_magia: "poder_magia",
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
        const files = loadJsonFiles<Record<string, unknown>>(subPath)
        rows.push(...files.map((p) => {
          const rawType = (p.sub_type as string | undefined) ?? (p.type as string | undefined) ?? "poder_geral"
          const type = PODER_GERAL_TYPE_MAP[rawType] ?? rawType
          return mapPoder(p, type, null, null)
        }))
      }
      continue
    }

    if (topDir === "poderes_distincao") {
      for (const distincaoDir of readdirSync(topPath)) {
        const distincaoPath = join(topPath, distincaoDir)
        if (!statSync(distincaoPath).isDirectory()) continue
        const files = loadJsonDir<Record<string, unknown>>(distincaoPath)
        rows.push(...files.map((p) => mapPoder(p, "poder_distincao", null, null, distincaoDir)))
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

function mapPoder(
  p: Record<string, unknown>,
  type: string,
  originId: string | null,
  classId: string | null,
  distincaoId: string | null = null
): Record<string, unknown> {
  return {
    id: p.id, name: p.name, type,
    description: p.description ?? null,
    effects: jsonOrNull(p.effects ?? (type === "poder_classe" || type === "habilidade_de_raca" ? {} : [])),
    costs: jsonOrNull(p.costs ?? []),
    prerequisites: jsonOrNull(p.requirements ?? p.prerequisites ?? []),
    origin_id: originId, class_id: classId, distincao_id: distincaoId,
    deities: p.deities ?? [],
    livro_id: livroIdOf(p),
  }
}

function seedMagias(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const magias = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "magias"))
  insert("magias", magias.map((m) => {
    const target = Array.isArray(m.target) ? m.target[0] : (m.target as Record<string, unknown> | null)
    const details = (isPlainObject(m.effect_details) ? m.effect_details : {}) as Record<string, unknown>
    const extra = (isPlainObject(m.extra_costs) ? m.extra_costs : {}) as Record<string, unknown>
    return {
      id: m.id, name: m.name, type: m.type, circle: m.circle, school: m.school,
      execution: m.execution, execution_details: m.execution_details ?? null,
      range: m.range, duration: m.duration, duration_details: m.duration_details ?? null,
      counterspell: m.counterspell ?? null, description: m.description,
      target_amount: target?.amount ?? null,
      target_up_to: target?.up_to === undefined || target?.up_to === null ? null : (target.up_to ? 1 : 0),
      target_type: target?.type ?? null,
      effect: m.effect ?? null, effect_shape: details.shape ?? null, effect_dimention: details.dimention ?? null,
      effect_size: details.size ?? null, effect_other_details: details.other_details ?? null,
      area_effect: m.area_effect ?? null, area_effect_details: m.area_effect_details ?? null,
      resistence_effect: (m.resistence as Record<string, unknown>)?.effect ?? null,
      resistence_skill: (m.resistence as Record<string, unknown>)?.skill ?? null,
      extra_costs_material_component: extra.material_component ?? null,
      extra_costs_material_cost: extra.material_component_cost ?? null,
      extra_costs_pm_debuff: extra.pm_debuff ?? null, extra_costs_pm_sacrifice: extra.pm_sacrifice ?? null,
      enhancements: m.enhancements ?? [], effects: m.effects ?? [],
      livro_id: livroIdOf(m),
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
    properties: [a.habilidades, a.especial].flat().filter((x) => x !== undefined && x !== null),
    description: a.description ?? null,
    livro_id: livroIdOf(a),
  })))

  const armaduras = loadJsonFiles<Record<string, unknown>>(join(eqDir, "armaduras"))
  insert("armaduras", armaduras.map((a) => ({
    id: a.id, name: a.name, category: a.categoria ?? a.category,
    price: a.preco ?? a.price ?? 0,
    defense_bonus: a.bonus_defesa ?? a.defense_bonus ?? 0,
    armor_penalty: a.penalidade_armadura ?? 0,
    weight: a.espacos ?? a.weight ?? 0,
    properties: a.especial === undefined || a.especial === null ? [] : [a.especial],
    description: a.description ?? null,
    livro_id: livroIdOf(a),
  })))

  const escudos = loadJsonFiles<Record<string, unknown>>(join(eqDir, "escudos"))
  insert("escudos", escudos.map((e) => ({
    id: e.id, name: e.name,
    price: e.preco ?? e.price ?? 0,
    defense_bonus: e.bonus_defesa ?? e.defense_bonus ?? 0,
    armor_penalty: e.penalidade_armadura ?? e.armor_penalty ?? 0,
    weight: e.espacos ?? e.weight ?? 0,
    properties: e.properties ?? (e.especial === undefined || e.especial === null ? [] : [e.especial]),
    description: e.description ?? null,
    livro_id: livroIdOf(e),
  })))

  const itens = loadJsonFiles<Record<string, unknown>>(join(eqDir, "itens"))
  insert("itens", itens.map((i) => {
    const { id, name, categoria, preco, espacos, description, livro, ...effects } = i
    return {
      id, name, category: categoria ?? null,
      price: preco ?? null, weight: espacos ?? null,
      description: description ?? null,
      effects,
      livro_id: (livro as string | undefined) ?? "t20_eja",
    }
  }))
}

function seedItensSuperiores(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const dir = join(JSON_DIR, "itens_superiores")

  const materiais = loadJsonDir<Record<string, unknown>>(join(dir, "materiais_especiais"))
  insert("materiais_especiais", materiais.map((m) => ({
    id: m.id, name: m.name, description: m.description ?? null,
    applicable_to: m.applicable_to ?? [], price_modifier: m.price_modifier ?? m.precos_adicionais ?? {},
    effects: m.efeitos ?? m.effects ?? {},
    livro_id: livroIdOf(m),
  })))

  const melhorias = loadJsonFiles<Record<string, unknown>>(join(dir, "melhorias"))
  insert("melhorias", melhorias.map((m) => ({
    id: m.id, name: m.name, description: m.description ?? null,
    applicable_to: m.applicable_to ?? (m.categoria === undefined || m.categoria === null ? [] : [m.categoria].flat()),
    price: m.price ?? null,
    effects: m.effects ?? {},
    livro_id: livroIdOf(m),
  })))

  const encantamentos = loadJsonFiles<Record<string, unknown>>(join(dir, "encantamentos"))
  insert("encantamentos", encantamentos.map((e) => ({
    id: e.id, name: e.name, description: e.description ?? null,
    categoria: e.categoria ?? "arma",
    escudo_only: e.escudo_only ? 1 : 0,
    conta_como_dois: e.conta_como_dois ? 1 : 0,
    maldicao: e.maldicao ? 1 : 0,
    prerequisitos: e.prerequisitos ?? [],
    effects: e.effects ?? [],
    livro_id: livroIdOf(e),
  })))
}

function seedCondicoes(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const condicoes = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "condicoes"))
  insert("condicoes", condicoes.map((c) => ({
    id: c.id, name: c.name, description: c.description ?? null,
    effects: c.effects ?? [], condition_type: c.condition_type ?? c.tipo ?? null,
    escalates_to: c.escalates_to ?? null,
    livro_id: livroIdOf(c),
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
    livro_id: livroIdOf(p),
  })))
}

function seedClassesVariantes(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "classes_variantes"))) return
  const rows = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "classes_variantes"))
  insert("classes_variantes", rows.map((r) => ({
    id: r.id, name: r.name, base_class_id: r.base_class_id,
    description: r.description ?? null, diffs: r.diffs ?? [],
    livro_id: livroIdOf(r),
  })))
}

function seedDistincoes(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "distincoes"))) return
  const rows = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "distincoes"))
  insert("distincoes", rows.map((r) => ({
    id: r.id, name: r.name, description: r.description ?? null,
    admissao: r.admissao ?? null, marca_nome: r.marca_nome ?? null,
    marca_descricao: r.marca_descricao ?? null, nivel_minimo: r.nivel_minimo ?? null,
    livro_id: livroIdOf(r),
  })))
}

function seedComplicacoes(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "complicacoes"))) return
  const rows = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "complicacoes"))
  insert("complicacoes", rows.map((r) => ({
    id: r.id, name: r.name, description: r.description ?? null,
    categoria: r.categoria ?? "geral", effects: r.effects ?? [],
    livro_id: livroIdOf(r),
  })))
}

function seedBasesTipos(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "bases_tipos"))) return
  const rows = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "bases_tipos"))
  insert("bases_tipos", rows.map((r) => ({
    id: r.id, name: r.name, description: r.description ?? null,
    effects: r.effects ?? [],
    livro_id: livroIdOf(r),
  })))
}

function seedComodos(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "comodos"))) return
  const rows = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "comodos"))
  insert("comodos", rows.map((r) => ({
    id: r.id, name: r.name, description: r.description ?? null,
    effects: r.effects ?? [], prerequisito: r.prerequisito ?? null,
    livro_id: livroIdOf(r),
  })))
}

function seedMobilias(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "mobilias"))) return
  const rows = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "mobilias"))
  insert("mobilias", rows.map((r) => ({
    id: r.id, name: r.name, description: r.description ?? null,
    effects: r.effects ?? [], preco: r.preco ?? null,
    comodo_alvo: r.comodo_alvo ?? null,
    livro_id: livroIdOf(r),
  })))
}

function seedConstrucoesDominio(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "construcoes_dominio"))) return
  const rows = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "construcoes_dominio"))
  insert("construcoes_dominio", rows.map((r) => ({
    id: r.id, name: r.name, description: r.description ?? null,
    categoria: r.categoria, custo: r.custo ?? null,
    effects: r.effects ?? [], prerequisito: r.prerequisito ?? null,
    livro_id: livroIdOf(r),
  })))
}

function seedRegras(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "regras"))) return
  const regras = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "regras"))
  insert("regras", regras.map((r) => {
    const { id, name, description, livro, livro_id, ...rest } = r
    return { id, name, description: description ?? null, data: rest, livro_id: (livro_id as string | undefined) ?? (livro as string | undefined) ?? "t20_eja" }
  }))
}

function seedTabelas(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "tabelas"))) return
  const tabelas = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "tabelas"))
  insert("tabelas", tabelas.map((t) => ({
    id: t.id, name: t.name, description: t.description ?? null,
    headers: t.headers ?? [],
    rows: t.rows ?? [],
    dice: t.dice ?? null,
    livro_id: livroIdOf(t),
  })))
}

function seedLivros(insert: ReturnType<typeof Database.prototype.transaction>): void {
  if (!existsDir(join(JSON_DIR, "livros"))) return
  const livros = loadJsonDir<Record<string, unknown>>(join(JSON_DIR, "livros"))
  insert("livros", livros.map((l) => ({
    id: l.id, nome: l.nome, nome_curto: l.nome_curto,
  })))
}

function seedItensmagicos(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const base = join(JSON_DIR, "itens_magicos")

  if (existsDir(join(base, "pocoes"))) {
    const pocoes = loadJsonDir<Record<string, unknown>>(join(base, "pocoes"))
    insert("pocoes", pocoes.map((p) => ({
      id: p.id, name: p.name, subtipo: p.subtipo, spell_id: p.spell_id,
      pm_cost: p.pm_cost, categoria: p.categoria, preco: p.preco ?? null,
      roll_min: p.roll_min ?? null, roll_max: p.roll_max ?? null,
      aprimoramento: p.aprimoramento ?? null, description: p.description ?? null,
      livro_id: livroIdOf(p),
    })))
  }

  if (existsDir(join(base, "acessorios"))) {
    const acessorios = loadJsonDir<Record<string, unknown>>(join(base, "acessorios"))
    insert("acessorios_magicos", acessorios.map((a) => ({
      id: a.id, name: a.name, categoria: a.categoria, preco: a.preco ?? null,
      roll_min: a.roll_min ?? null, roll_max: a.roll_max ?? null,
      description: a.description ?? null, effects: a.effects ?? [],
      livro_id: livroIdOf(a),
    })))
  }

  if (existsDir(join(base, "esotericos"))) {
    const esotericos = loadJsonDir<Record<string, unknown>>(join(base, "esotericos"))
    insert("esotericos_magicos", esotericos.map((e) => ({
      id: e.id, name: e.name, categoria: e.categoria, preco: e.preco ?? null,
      roll_min: e.roll_min ?? null, roll_max: e.roll_max ?? null,
      description: e.description ?? null, effects: e.effects ?? [],
      livro_id: livroIdOf(e),
    })))
  }
}

function seedIndiceRemissivo(): void {
  if (!existsDir(join(JSON_DIR, "indice_remissivo"))) return
  const rows: Record<string, unknown>[] = []

  for (const file of readdirSync(join(JSON_DIR, "indice_remissivo"))) {
    if (!file.endsWith(".json")) continue
    const livroId = file.replace(".json", "")
    const entries = JSON.parse(readFileSync(join(JSON_DIR, "indice_remissivo", file), "utf-8")) as Record<string, unknown>[]
    if (!Array.isArray(entries)) continue
    for (const e of entries) {
      if (!e.termo || !e.pagina) continue
      rows.push({
        livro_id: livroId,
        termo: e.termo,
        pagina: Number(e.pagina),
        tabela: e.tabela ?? null,
        registro_id: e.registro_id ?? null,
      })
    }
  }

  if (rows.length === 0) return
  const db2 = new Database(DB_PATH)
  const stmt = db2.prepare("INSERT OR REPLACE INTO indice_remissivo (livro_id, termo, pagina, tabela, registro_id) VALUES (?, ?, ?, ?, ?)")
  const run = db2.transaction(() => {
    for (const r of rows) stmt.run(r.livro_id, r.termo, r.pagina, r.tabela, r.registro_id)
  })
  run()
  db2.close()
}

function seedArmasMagicasEspecificas(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const dir = join(JSON_DIR, "itens_magicos", "armas_especificas")
  if (!existsDir(dir)) return
  const rows = loadJsonDir<Record<string, unknown>>(dir)
  insert("armas_magicas_especificas", rows.map((r) => ({
    id: r.id, name: r.name,
    base_weapon: r.base_weapon ?? null,
    preco: r.preco ?? null,
    description: r.description ?? null,
    effects: r.effects ?? [],
    livro_id: livroIdOf(r),
  })))
}

function seedArmadurasEscudosMagicos(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const dir = join(JSON_DIR, "itens_magicos", "armaduras_especificas")
  if (!existsDir(dir)) return
  const rows = loadJsonDir<Record<string, unknown>>(dir)
  insert("armaduras_magicas_especificas", rows.map((r) => ({
    id: r.id, name: r.name,
    subtipo: r.subtipo ?? "armadura",
    base_item: r.base_item ?? null,
    preco: r.preco ?? null,
    description: r.description ?? null,
    effects: r.effects ?? [],
    livro_id: livroIdOf(r),
  })))
}

function seedItensLiturgicos(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const dir = join(JSON_DIR, "itens_magicos", "itens_liturgicos")
  if (!existsDir(dir)) return
  const rows = loadJsonDir<Record<string, unknown>>(dir)
  insert("itens_liturgicos", rows.map((r) => ({
    id: r.id, name: r.name,
    deities: r.deities ?? [],
    subtipo: r.subtipo ?? null,
    base_item: r.base_item ?? null,
    classificacao: r.classificacao ?? null,
    preco: r.preco ?? null,
    description: r.description ?? null,
    effects: r.effects ?? [],
    livro_id: livroIdOf(r),
  })))
}

function seedArtefatos(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const dir = join(JSON_DIR, "itens_magicos", "artefatos")
  if (!existsDir(dir)) return
  const rows = loadJsonDir<Record<string, unknown>>(dir)
  insert("artefatos", rows.map((r) => ({
    id: r.id, name: r.name,
    description: r.description ?? null,
    effects: r.effects ?? [],
    livro_id: livroIdOf(r),
  })))
}

function seedAmeacas(insert: ReturnType<typeof Database.prototype.transaction>): void {
  const dir = join(JSON_DIR, "ameacas")
  if (!existsDir(dir)) return
  const rows = loadJsonFiles<Record<string, unknown>>(dir)
  insert("ameacas", rows.map((r) => {
    const attrs = (r.atributos as Record<string, number>) ?? {}
    return {
      id: r.id, name: r.name, nd: r.nd,
      tipo: r.tipo ?? null, subtipo: r.subtipo ?? null,
      tamanho: r.tamanho ?? "médio", grupo: r.grupo,
      pv: r.pv ?? null, defesa: r.defesa ?? null,
      for: attrs.for ?? null, des: attrs.des ?? null, con: attrs.con ?? null,
      int: attrs.int ?? null, sab: attrs.sab ?? null, car: attrs.car ?? null,
      iniciativa: r.iniciativa ?? null,
      deslocamento: r.deslocamento ?? null,
      salvaguardas: r.salvaguardas ?? {},
      percepcao: r.percepcao ?? null,
      visao: r.visao ?? null,
      ataques: r.ataques ?? [],
      poderes_especiais: r.poderes_especiais ?? [],
      imunidades: r.imunidades ?? [],
      resistencias: r.resistencias ?? {},
      vulnerabilidades: r.vulnerabilidades ?? [],
      reducao_de_dano: jsonOrNull(r.reducao_de_dano),
      cura_acelerada: jsonOrNull(r.cura_acelerada),
      resistencia_a_magia: r.resistencia_a_magia ?? null,
      pericias: r.pericias ?? {},
      equipamento: r.equipamento ?? [],
      tesouro: r.tesouro ?? null,
      pm: r.pm ?? null,
      description: r.description ?? null,
      familiar: jsonOrNull(r.familiar),
      parceiro: jsonOrNull(r.parceiro),
      livro_id: livroIdOf(r),
    }
  }))
}

function existsDir(path: string): boolean {
  try { return statSync(path).isDirectory() } catch { return false }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  seed()
}
