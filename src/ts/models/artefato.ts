import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "artefatos"

/**
 * An artifact — unique, extremely powerful magic item from Tormenta20 (Cap. 8, pp. 350–353).
 *
 * @example
 * ```ts
 * Artefato.all()
 * Artefato.find("espada_deus")
 * ```
 */
export class Artefato extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of mechanical effects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  toH() {
    return { id: this.id, name: this.name, description: this.description, effects: this.effects }
  }

  static query(): Query<Artefato> { return BaseModel.makeQuery(TABLE, Artefato) }
  static all(): Artefato[] { return Artefato.query().all() }
  static find(id: string): Artefato | null { return Artefato.query().find(id) }
  static first(): Artefato | null { return Artefato.query().first() }
  static last(): Artefato | null { return Artefato.query().last() }
  static count(): number { return Artefato.query().count() }
}
