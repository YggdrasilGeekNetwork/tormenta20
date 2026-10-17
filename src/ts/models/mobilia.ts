import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "mobilias"

/**
 * A Mobília (headquarters furniture) in Tormenta20.
 *
 * A catalog of furniture items that can be installed in a {@link Comodo} to grant
 * an additional bonus. Some are restricted to a specific cômodo (`comodoAlvo`).
 * Only catalog data lives here — see {@link BaseTipo}.
 *
 * @example
 * ```ts
 * Mobilia.find("bar")
 * ```
 */
export class Mobilia extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of typed mechanical effect objects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }
  /** Price in tibares. */
  get preco(): number | null { return (this._row.preco as number) ?? null }
  /** Id of the cômodo this mobília must be installed in, or `null` if unrestricted. */
  get comodoAlvo(): string | null { return (this._row.comodo_alvo as string) ?? null }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description,
      effects: this.effects, preco: this.preco, comodo_alvo: this.comodoAlvo,
    }
  }

  static query(): Query<Mobilia> { return BaseModel.makeQuery(TABLE, Mobilia) }
  static all(): Mobilia[] { return Mobilia.query().all() }
  static find(id: string): Mobilia | null { return Mobilia.query().find(id) }
  static first(): Mobilia | null { return Mobilia.query().first() }
  static last(): Mobilia | null { return Mobilia.query().last() }
  static count(): number { return Mobilia.query().count() }
}
