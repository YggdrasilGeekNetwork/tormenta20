import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "condicoes"

/**
 * Category of a condition, used to group conditions by mechanical theme.
 *
 * `medo` · `mental` · `metabolismo` · `movimento` · `veneno` · `sentidos` · `cansaco` · `metamorfose`
 */
export type CondicaoType = "medo" | "mental" | "metabolismo" | "movimento" | "veneno" | "sentidos" | "cansaco" | "metamorfose"

/**
 * A Condição (status condition) in Tormenta20.
 *
 * @example
 * ```ts
 * Condicao.all()
 * Condicao.medo().all()
 * Condicao.find("abalado")
 *
 * const abalado = Condicao.find("abalado")!
 * abalado.escalatesTo   // "apavorado" (next condition in the fear chain)
 * ```
 */
export class Condicao extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of mechanical effect objects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }
  get conditionType(): CondicaoType | null { return (this._row.condition_type as CondicaoType) ?? null }
  /** ID of the more severe condition this escalates to, or `null`. */
  get escalatesTo(): string | null { return (this._row.escalates_to as string) ?? null }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description,
      effects: this.effects, condition_type: this.conditionType, escalates_to: this.escalatesTo,
    }
  }

  static query(): Query<Condicao> { return BaseModel.makeQuery(TABLE, Condicao) }
  static all(): Condicao[] { return Condicao.query().all() }
  static find(id: string): Condicao | null { return Condicao.query().find(id) }
  static first(): Condicao | null { return Condicao.query().first() }
  static last(): Condicao | null { return Condicao.query().last() }
  static count(): number { return Condicao.query().count() }

  static byType(type: CondicaoType): Query<Condicao> { return Condicao.query().where("condition_type = ?", type) }
  static medo(): Query<Condicao> { return Condicao.byType("medo") }
  static mental(): Query<Condicao> { return Condicao.byType("mental") }
  static metabolismo(): Query<Condicao> { return Condicao.byType("metabolismo") }
  static movimento(): Query<Condicao> { return Condicao.byType("movimento") }
}
