import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "bases_tipos"

/**
 * A Tipo de Base (headquarters type) in Tormenta20.
 *
 * Represents the physical nature of a group's headquarters (Esconderijo,
 * Fortificação, Móvel, Residência, Centro de Poder, Empreendimento) and the
 * passive bonuses it grants its residents. Only catalog data lives here — an
 * actual base built by a group (with a chosen type, porte, cômodos, and
 * mobílias) is campaign state, not gem content.
 *
 * @example
 * ```ts
 * BaseTipo.find("fortificacao")
 * ```
 */
export class BaseTipo extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of typed mechanical effect objects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  toH() {
    return { id: this.id, name: this.name, description: this.description, effects: this.effects }
  }

  static query(): Query<BaseTipo> { return BaseModel.makeQuery(TABLE, BaseTipo) }
  static all(): BaseTipo[] { return BaseTipo.query().all() }
  static find(id: string): BaseTipo | null { return BaseTipo.query().find(id) }
  static first(): BaseTipo | null { return BaseTipo.query().first() }
  static last(): BaseTipo | null { return BaseTipo.query().last() }
  static count(): number { return BaseTipo.query().count() }
}
