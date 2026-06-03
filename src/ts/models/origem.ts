import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "origens"

/**
 * An Origem (character origin/background) in Tormenta20.
 *
 * Origins grant starting equipment, skill training, powers, and optionally
 * a unique ability (`uniquePower`).
 *
 * @example
 * ```ts
 * Origem.all()
 * Origem.withUniquePower().all()
 * Origem.find("nobre")
 *
 * const nobre = Origem.find("nobre")!
 * nobre.skills()   // ["Diplomacia", "Nobreza"]
 * nobre.powers()   // ["poder_id"]
 * ```
 */
export class Origem extends BaseModel {
  get description(): string { return this._row.description as string }
  /** Starting equipment descriptors. */
  get items(): unknown[] { return BaseModel.json(this._row.items, []) }
  /** Raw benefits object with `skills` and `powers` arrays. */
  get benefits(): Record<string, unknown> { return BaseModel.json(this._row.benefits, {}) }
  /** ID of the unique power granted by this origin, or `null`. */
  get uniquePower(): string | null { return (this._row.unique_power as string) ?? null }

  /** Returns skill IDs granted by this origin. */
  skills(): string[] { return (this.benefits.skills as string[]) ?? [] }
  /** Returns power IDs granted by this origin. */
  powers(): string[] { return (this.benefits.powers as string[]) ?? [] }
  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description,
      items: this.items, benefits: this.benefits, unique_power: this.uniquePower,
    }
  }

  static query(): Query<Origem> { return BaseModel.makeQuery(TABLE, Origem) }
  static all(): Origem[] { return Origem.query().all() }
  static find(id: string): Origem | null { return Origem.query().find(id) }
  static first(): Origem | null { return Origem.query().first() }
  static last(): Origem | null { return Origem.query().last() }
  static count(): number { return Origem.query().count() }
  /** Returns only origins that have a unique ability. */
  static withUniquePower(): Query<Origem> { return Origem.query().where("unique_power IS NOT NULL") }
}
