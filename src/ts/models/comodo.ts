import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "comodos"

/**
 * A Cômodo (headquarters room) in Tormenta20.
 *
 * A catalog of rooms a group can build inside their base, each granting a
 * passive bonus to residents. Some have a `prerequisito` (e.g. another cômodo, or
 * a minimum porte). Only catalog data lives here — see {@link BaseTipo}.
 *
 * @example
 * ```ts
 * Comodo.find("biblioteca")
 * ```
 */
export class Comodo extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of typed mechanical effect objects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }
  /** Free-text or id of a prerequisite cômodo/porte, if any. */
  get prerequisito(): string | null { return (this._row.prerequisito as string) ?? null }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description,
      effects: this.effects, prerequisito: this.prerequisito,
    }
  }

  static query(): Query<Comodo> { return BaseModel.makeQuery(TABLE, Comodo) }
  static all(): Comodo[] { return Comodo.query().all() }
  static find(id: string): Comodo | null { return Comodo.query().find(id) }
  static first(): Comodo | null { return Comodo.query().first() }
  static last(): Comodo | null { return Comodo.query().last() }
  static count(): number { return Comodo.query().count() }
}
