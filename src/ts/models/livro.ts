import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "livros"

/**
 * A Livro (sourcebook) in Tormenta20.
 *
 * Used internally as the target of `indice_remissivo` entries.
 *
 * @example
 * ```ts
 * Livro.all()
 * Livro.find("t20jaf")
 * ```
 */
export class Livro extends BaseModel {
  // livros uses `nome` column, not `name`
  override get name(): string { return this._row.nome as string }
  /** Short name used in formatted references (e.g. `"T20JAF"`). */
  get nomeCurto(): string { return this._row.nome_curto as string }

  toH() {
    return { id: this.id, nome: this.name, nome_curto: this.nomeCurto }
  }

  static query(): Query<Livro> { return BaseModel.makeQuery(TABLE, Livro) }
  static all(): Livro[] { return Livro.query().all() }
  static find(id: string): Livro | null { return Livro.query().find(id) }
  static first(): Livro | null { return Livro.query().first() }
  static last(): Livro | null { return Livro.query().last() }
  static count(): number { return Livro.query().count() }
}
