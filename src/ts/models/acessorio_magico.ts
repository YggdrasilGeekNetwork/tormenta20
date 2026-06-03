import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "acessorios_magicos"

/**
 * An Acessório Mágico (magic accessory) in Tormenta20.
 *
 * Includes rings, amulets, cloaks, and other slotted magic items.
 *
 * @example
 * ```ts
 * AcessorioMagico.all()
 * AcessorioMagico.menores().all()
 * AcessorioMagico.maiores().all()
 * AcessorioMagico.find("anel_de_protecao")
 * ```
 */
export class AcessorioMagico extends BaseModel {
  /** Type of accessory (e.g. `"anel"`, `"amuleto"`, `"capa"`). */
  get categoria(): string { return this._row.categoria as string }
  /** Price in tibares. */
  get preco(): number { return (this._row.preco as number) ?? 0 }
  /** Minimum roll on the random loot table, or `null`. */
  get rollMin(): number | null { return (this._row.roll_min as number) ?? null }
  /** Maximum roll on the random loot table, or `null`. */
  get rollMax(): number | null { return (this._row.roll_max as number) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON object with mechanical effects. */
  get efeito(): Record<string, unknown> { return BaseModel.json(this._row.efeito, {}) }

  toH() {
    return {
      id: this.id, name: this.name, categoria: this.categoria, preco: this.preco,
      roll_min: this.rollMin, roll_max: this.rollMax,
      description: this.description, efeito: this.efeito,
    }
  }

  static query(): Query<AcessorioMagico> { return BaseModel.makeQuery(TABLE, AcessorioMagico) }
  static all(): AcessorioMagico[] { return AcessorioMagico.query().all() }
  static find(id: string): AcessorioMagico | null { return AcessorioMagico.query().find(id) }
  static first(): AcessorioMagico | null { return AcessorioMagico.query().first() }
  static last(): AcessorioMagico | null { return AcessorioMagico.query().last() }
  static count(): number { return AcessorioMagico.query().count() }

  static menores(): Query<AcessorioMagico> { return AcessorioMagico.query().where("categoria = ?", "menor") }
  static medios(): Query<AcessorioMagico> { return AcessorioMagico.query().where("categoria = ?", "medio") }
  static maiores(): Query<AcessorioMagico> { return AcessorioMagico.query().where("categoria = ?", "maior") }
}
