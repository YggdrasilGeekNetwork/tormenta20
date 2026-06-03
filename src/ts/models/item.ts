import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "itens"

/**
 * A general adventuring Item in Tormenta20 (tools, supplies, etc.).
 *
 * Does not include weapons, armors, or shields — those have dedicated models.
 *
 * @example
 * ```ts
 * Item.all()
 * Item.byCategory("alquimia").all()
 * Item.find("kit_de_aventureiro")
 * ```
 */
export class Item extends BaseModel {
  get category(): string | null { return (this._row.category as string) ?? null }
  /** Price in tibares. */
  get price(): number { return (this._row.price as number) ?? 0 }
  /** Weight in spaces (espaços). */
  get weight(): number { return (this._row.weight as number) ?? 0 }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON object with mechanical effects (varies by item). */
  get effects(): Record<string, unknown> { return BaseModel.json(this._row.effects, {}) }

  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, category: this.category, price: this.price,
      weight: this.weight, description: this.description, effects: this.effects,
    }
  }

  static query(): Query<Item> { return BaseModel.makeQuery(TABLE, Item) }
  static all(): Item[] { return Item.query().all() }
  static find(id: string): Item | null { return Item.query().find(id) }
  static first(): Item | null { return Item.query().first() }
  static last(): Item | null { return Item.query().last() }
  static count(): number { return Item.query().count() }

  static byCategory(cat: string): Query<Item> { return Item.query().where("category = ?", cat) }
}
