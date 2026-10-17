import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "complicacoes"

/**
 * A Complicação (character complication) in Tormenta20.
 *
 * Chosen at character creation: the player accepts a mechanical drawback (`effects`)
 * in exchange for freely picking any one general power whose prerequisites they meet
 * (not a fixed grant tied to the complication — the gem doesn't model that choice, it
 * belongs to the consumer's character-creation flow). `categoria` is `"geral"` for
 * complications any character can take, or a class id (e.g. `"guerreiro"`) for
 * complications specific to that class.
 *
 * @example
 * ```ts
 * Complicacao.gerais().all()
 * Complicacao.byCategoria("guerreiro").all()
 * ```
 */
export class Complicacao extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** `"geral"`, or a class id for class-specific complications. */
  get categoria(): string { return this._row.categoria as string }
  /** JSON array of typed mechanical drawback effects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description, categoria: this.categoria,
      effects: this.effects,
    }
  }

  static query(): Query<Complicacao> { return BaseModel.makeQuery(TABLE, Complicacao) }
  static all(): Complicacao[] { return Complicacao.query().all() }
  static find(id: string): Complicacao | null { return Complicacao.query().find(id) }
  static first(): Complicacao | null { return Complicacao.query().first() }
  static last(): Complicacao | null { return Complicacao.query().last() }
  static count(): number { return Complicacao.query().count() }

  static gerais(): Query<Complicacao> { return Complicacao.query().where("categoria = ?", "geral") }
  static byCategoria(categoria: string): Query<Complicacao> {
    return Complicacao.query().where("categoria = ?", categoria)
  }
}
