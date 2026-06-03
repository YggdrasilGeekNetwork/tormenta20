import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "magias"

/** Tradition of the spell. */
export type MagiaType = "arcana" | "divina" | "universal"

/**
 * Magic school abbreviations used in Tormenta20.
 *
 * `abjur` · `adiv` · `conv` · `encan` · `evoc` · `ilus` · `necro` · `trans`
 */
export type MagiaSchool = "abjur" | "adiv" | "conv" | "encan" | "evoc" | "ilus" | "necro" | "trans"

/**
 * A Magia (spell) in Tormenta20.
 *
 * @example
 * ```ts
 * Magia.arcanas().where("circle = ?", "3").all()
 * Magia.divinas().all()
 * Magia.bySchool("necro").all()
 * Magia.find("bola_de_fogo")
 * ```
 */
export class Magia extends BaseModel {
  get type(): MagiaType { return this._row.type as MagiaType }
  /** Circle (level) of the spell, stored as a string (e.g. `"1"`, `"2"`, `"3"`). */
  get circle(): string { return this._row.circle as string }
  get school(): MagiaSchool { return this._row.school as MagiaSchool }
  /** Casting time (e.g. `"padrão"`, `"completa"`). */
  get execution(): string { return this._row.execution as string }
  get executionDetails(): string | null { return (this._row.execution_details as string) ?? null }
  get range(): string { return this._row.range as string }
  get duration(): string { return this._row.duration as string }
  get durationDetails(): string | null { return (this._row.duration_details as string) ?? null }
  /** ID of the counterspell, or `null`. */
  get counterspell(): string | null { return (this._row.counterspell as string) ?? null }
  get description(): string { return this._row.description as string }
  /** JSON array of enhancement objects (aprimoramentos). */
  get enhancements(): unknown[] { return BaseModel.json(this._row.enhancements, []) }
  /** JSON array of mechanical effect objects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  /**
   * Returns target information, or `null` if the spell has no specific target count/type.
   */
  targetInfo(): { amount: number | null; upTo: boolean; type: string | null } | null {
    const amount = this._row.target_amount as number | null
    const type = this._row.target_type as string | null
    if (!amount && !type) return null
    return { amount: amount ?? null, upTo: !!(this._row.target_up_to), type: type ?? null }
  }

  /**
   * Returns resistance information (saving throw), or `null` if the spell allows no save.
   */
  resistenceInfo(): { effect: string; skill: string } | null {
    const e = this._row.resistence_effect as string
    const s = this._row.resistence_skill as string
    if (!e && !s) return null
    return { effect: e, skill: s }
  }

  /**
   * Returns extra casting costs (material components, PM sacrifice, etc.),
   * or `null` if none exist.
   */
  extraCostsInfo(): Record<string, unknown> | null {
    const fields = ["extra_costs_material_component", "extra_costs_material_cost", "extra_costs_pm_debuff", "extra_costs_pm_sacrifice"]
    const result: Record<string, unknown> = {}
    for (const f of fields) {
      if (this._row[f]) result[f.replace("extra_costs_", "")] = this._row[f]
    }
    return Object.keys(result).length > 0 ? result : null
  }

  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, type: this.type, circle: this.circle, school: this.school,
      execution: this.execution, execution_details: this.executionDetails, range: this.range,
      duration: this.duration, duration_details: this.durationDetails, counterspell: this.counterspell,
      description: this.description, target: this.targetInfo(), resistence: this.resistenceInfo(),
      extra_costs: this.extraCostsInfo(), enhancements: this.enhancements, effects: this.effects,
    }
  }

  static query(): Query<Magia> { return BaseModel.makeQuery(TABLE, Magia) }
  static all(): Magia[] { return Magia.query().all() }
  static find(id: string): Magia | null { return Magia.query().find(id) }
  static first(): Magia | null { return Magia.query().first() }
  static last(): Magia | null { return Magia.query().last() }
  static count(): number { return Magia.query().count() }

  static byType(type: MagiaType): Query<Magia> { return Magia.query().where("type = ?", type) }
  static byCircle(circle: string): Query<Magia> { return Magia.query().where("circle = ?", circle) }
  static bySchool(school: MagiaSchool): Query<Magia> { return Magia.query().where("school = ?", school) }

  static arcanas(): Query<Magia> { return Magia.byType("arcana") }
  static divinas(): Query<Magia> { return Magia.byType("divina") }
  static universais(): Query<Magia> { return Magia.byType("universal") }
  static doCirculo(circle: string): Query<Magia> { return Magia.byCircle(circle) }
  static daEscola(school: MagiaSchool): Query<Magia> { return Magia.bySchool(school) }
}
