import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "armas"

/** Proficiency category of a weapon. */
export type ArmaCategory = "simples" | "marciais" | "exoticas" | "fogo"

/** Physical damage type dealt by a weapon. */
export type DamageType = "corte" | "perfuracao" | "impacto"

/**
 * An Arma (weapon) in Tormenta20.
 *
 * @example
 * ```ts
 * Arma.marciais().all()
 * Arma.ranged().all()
 * Arma.melee().where("damage_type = ?", "corte").all()
 * Arma.find("espada_longa")
 * ```
 */
export class Arma extends BaseModel {
  get category(): ArmaCategory { return this._row.category as ArmaCategory }
  /** Price in tibares. */
  get price(): number { return (this._row.price as number) ?? 0 }
  /** Damage dice expression (e.g. `"1d8"`). */
  get damage(): string { return this._row.damage as string }
  get damageType(): DamageType { return this._row.damage_type as DamageType }
  /** Critical threat range and multiplier (e.g. `"19-20/x2"`). */
  get critical(): string { return this._row.critical as string }
  /** Range increment in metres, or `null` for melee-only weapons. */
  get range(): string | null { return (this._row.range as string) || null }
  /** Weight in spaces (espaços). */
  get weight(): number { return (this._row.weight as number) ?? 0 }
  /** JSON array of special property objects. */
  get properties(): unknown[] { return BaseModel.json(this._row.properties, []) }
  get description(): string | null { return (this._row.description as string) ?? null }

  /** `true` if the weapon has a range increment. */
  get isRanged(): boolean { return this.range !== null }
  /** `true` if the weapon is melee-only. */
  get isMelee(): boolean { return !this.isRanged }

  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, category: this.category, price: this.price,
      damage: this.damage, damage_type: this.damageType, critical: this.critical,
      range: this.range, weight: this.weight, properties: this.properties,
      description: this.description,
    }
  }

  static query(): Query<Arma> { return BaseModel.makeQuery(TABLE, Arma) }
  static all(): Arma[] { return Arma.query().all() }
  static find(id: string): Arma | null { return Arma.query().find(id) }
  static first(): Arma | null { return Arma.query().first() }
  static last(): Arma | null { return Arma.query().last() }
  static count(): number { return Arma.query().count() }

  static byCategory(cat: ArmaCategory): Query<Arma> { return Arma.query().where("category = ?", cat) }
  static byDamageType(dt: DamageType): Query<Arma> { return Arma.query().where("damage_type = ?", dt) }
  /** Returns weapons with a range increment. */
  static ranged(): Query<Arma> { return Arma.query().where("range IS NOT NULL AND range != ''") }
  /** Returns melee-only weapons. */
  static melee(): Query<Arma> { return Arma.query().where("range IS NULL OR range = ''") }

  static simples(): Query<Arma> { return Arma.byCategory("simples") }
  static marciais(): Query<Arma> { return Arma.byCategory("marciais") }
  static exoticas(): Query<Arma> { return Arma.byCategory("exoticas") }
  static fogo(): Query<Arma> { return Arma.byCategory("fogo") }
}
