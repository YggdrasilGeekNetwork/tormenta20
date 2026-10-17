import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "distincoes"

/**
 * A Distinção (distinction) in Tormenta20.
 *
 * Ties a character to an organization, philosophy, or people of Arton. Has
 * three parts: admissão (narrative requirement), marca (an ability granted
 * automatically on admission), and a set of exclusive powers. The powers
 * themselves live in {@link Poder} (`type: "poder_distincao"`, `distincaoId`
 * pointing back here) — not duplicated on this model.
 *
 * @example
 * ```ts
 * const d = Distincao.find("cavaleiro_do_corvo")
 * Poder.byDistincao(d.id).all()
 * ```
 */
export class Distincao extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** Narrative admission requirements. */
  get admissao(): string | null { return (this._row.admissao as string) ?? null }
  /** Name of the "Marca da Distinção" — the ability granted automatically on admission. */
  get marcaNome(): string | null { return (this._row.marca_nome as string) ?? null }
  /** Effect of the marca. */
  get marcaDescricao(): string | null { return (this._row.marca_descricao as string) ?? null }
  /** Minimum character level to acquire powers from this distinction (veterano = 5). */
  get nivelMinimo(): number { return (this._row.nivel_minimo as number) ?? 5 }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description,
      admissao: this.admissao, marca_nome: this.marcaNome, marca_descricao: this.marcaDescricao,
      nivel_minimo: this.nivelMinimo,
    }
  }

  static query(): Query<Distincao> { return BaseModel.makeQuery(TABLE, Distincao) }
  static all(): Distincao[] { return Distincao.query().all() }
  static find(id: string): Distincao | null { return Distincao.query().find(id) }
  static first(): Distincao | null { return Distincao.query().first() }
  static last(): Distincao | null { return Distincao.query().last() }
  static count(): number { return Distincao.query().count() }
}
