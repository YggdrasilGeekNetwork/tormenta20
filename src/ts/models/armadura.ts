import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "armaduras"

/** Weight class of an armor. */
export type ArmaduraCategory = "leve" | "pesada"

/**
 * An Armadura (armor) in Tormenta20.
 *
 * @example
 * ```ts
 * Armadura.leves().all()
 * Armadura.pesadas().all()
 * Armadura.find("cota_de_malha")
 * ```
 */
export class Armadura extends BaseModel {
  get category(): ArmaduraCategory { return this._row.category as ArmaduraCategory }
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

  get isLeve(): boolean { return this.category === "leve" }
  get isPesada(): boolean { return this.category === "pesada" }

  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, category: this.category, price: this.price,
      defense_bonus: this.defenseBonus, armor_penalty: this.armorPenalty,
      weight: this.weight, properties: this.properties, description: this.description,
    }
  }

  static query(): Query<Armadura> { return BaseModel.makeQuery(TABLE, Armadura) }
  static all(): Armadura[] { return Armadura.query().all() }
  static find(id: string): Armadura | null { return Armadura.query().find(id) }
  static first(): Armadura | null { return Armadura.query().first() }
  static last(): Armadura | null { return Armadura.query().last() }
  static count(): number { return Armadura.query().count() }

  static byCategory(cat: ArmaduraCategory): Query<Armadura> { return Armadura.query().where("category = ?", cat) }
  static leves(): Query<Armadura> { return Armadura.byCategory("leve") }
  static pesadas(): Query<Armadura> { return Armadura.byCategory("pesada") }
}
