import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "materiais_especiais"

/**
 * A Material Especial (special material) that equipment can be crafted from.
 *
 * @example
 * ```ts
 * MaterialEspecial.all()
 * MaterialEspecial.find("adamante")
 * ```
 */
export class MaterialEspecial extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of equipment types this material can be used for. */
  get applicableTo(): unknown[] { return BaseModel.json(this._row.applicable_to, []) }
  /** JSON object with price modifier data (multiplier or flat bonus). */
  get priceModifier(): Record<string, unknown> { return BaseModel.json(this._row.price_modifier, {}) }
  /** JSON object with mechanical effects granted by the material. */
  get effects(): Record<string, unknown> { return BaseModel.json(this._row.effects, {}) }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description,
      applicable_to: this.applicableTo, price_modifier: this.priceModifier, effects: this.effects,
    }
  }

  static query(): Query<MaterialEspecial> { return BaseModel.makeQuery(TABLE, MaterialEspecial) }
  static all(): MaterialEspecial[] { return MaterialEspecial.query().all() }
  static find(id: string): MaterialEspecial | null { return MaterialEspecial.query().find(id) }
  static first(): MaterialEspecial | null { return MaterialEspecial.query().first() }
  static last(): MaterialEspecial | null { return MaterialEspecial.query().last() }
  static count(): number { return MaterialEspecial.query().count() }
}
