import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "construcoes_dominio"

/** Domain building category. */
export type ConstrucaoDominioCategoria = "nobreza" | "guerra" | "enganacao" | "religiao" | "misticismo"

/**
 * A Construção de Domínio (domain building) in Tormenta20.
 *
 * A catalog of buildings a regent can erect in their domain (Cap. 4 "Domínios"),
 * each with a cost in Lingotes de Ouro (LO) and a mechanical benefit. Only catalog
 * data lives here — an actual domain's characteristics are campaign state, not gem
 * content. See also {@link BaseTipo} for the analogous pattern for group headquarters.
 *
 * @example
 * ```ts
 * ConstrucaoDominio.byCategoria("religiao").all()
 * ```
 */
export class ConstrucaoDominio extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  get categoria(): ConstrucaoDominioCategoria { return this._row.categoria as ConstrucaoDominioCategoria }
  /** Cost in Lingotes de Ouro (LO). */
  get custo(): number | null { return (this._row.custo as number) ?? null }
  /** JSON array of typed mechanical effect objects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }
  /** Free-text or id of a prerequisite building/terrain, if any. */
  get prerequisito(): string | null { return (this._row.prerequisito as string) ?? null }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description, categoria: this.categoria,
      custo: this.custo, effects: this.effects, prerequisito: this.prerequisito,
    }
  }

  static query(): Query<ConstrucaoDominio> { return BaseModel.makeQuery(TABLE, ConstrucaoDominio) }
  static all(): ConstrucaoDominio[] { return ConstrucaoDominio.query().all() }
  static find(id: string): ConstrucaoDominio | null { return ConstrucaoDominio.query().find(id) }
  static first(): ConstrucaoDominio | null { return ConstrucaoDominio.query().first() }
  static last(): ConstrucaoDominio | null { return ConstrucaoDominio.query().last() }
  static count(): number { return ConstrucaoDominio.query().count() }

  static byCategoria(categoria: string): Query<ConstrucaoDominio> {
    return ConstrucaoDominio.query().where("categoria = ?", categoria)
  }
}
