import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "escudos"

/**
 * An Escudo (shield) in Tormenta20.
 *
 * @example
 * ```ts
 * Escudo.all()
 * Escudo.find("escudo_leve")
 * ```
 */
export class Escudo extends BaseModel {
  /** Price in tibares. */
  get price(): number { return (this._row.price as number) ?? 0 }
  /** Bonus added to Defense. */
  get defenseBonus(): number { return this._row.defense_bonus as number }
  /** Penalty applied to Agility-based skills and attack rolls. */
  get armorPenalty(): number { return (this._row.armor_penalty as number) ?? 0 }
  /** Weight in spaces (espaços). */
  get weight(): number { return (this._row.weight as number) ?? 0 }
  /** JSON array of special property objects. */
  get properties(): unknown[] { return BaseModel.json(this._row.properties, []) }
  get description(): string | null { return (this._row.description as string) ?? null }

  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, price: this.price, defense_bonus: this.defenseBonus,
      armor_penalty: this.armorPenalty, weight: this.weight,
      properties: this.properties, description: this.description,
    }
  }

  static query(): Query<Escudo> { return BaseModel.makeQuery(TABLE, Escudo) }
  static all(): Escudo[] { return Escudo.query().all() }
  static find(id: string): Escudo | null { return Escudo.query().find(id) }
  static first(): Escudo | null { return Escudo.query().first() }
  static last(): Escudo | null { return Escudo.query().last() }
  static count(): number { return Escudo.query().count() }
}
