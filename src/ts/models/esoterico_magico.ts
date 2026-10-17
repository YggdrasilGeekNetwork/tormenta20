import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "esotericos_magicos"

/**
 * An Esotérico Mágico (magic caster implement) in Tormenta20.
 *
 * Includes staffs, wands, holy symbols, and other spellcasting foci.
 *
 * @example
 * ```ts
 * EsotericoMagico.all()
 * EsotericoMagico.menores().all()
 * EsotericoMagico.maiores().all()
 * EsotericoMagico.find("cajado_do_poder")
 * ```
 */
export class EsotericoMagico extends BaseModel {
  /** Power tier: `"menor"`, `"medio"`, or `"maior"`. */
  get categoria(): string { return this._row.categoria as string }
  /** Price in tibares. */
  get preco(): number { return (this._row.preco as number) ?? 0 }
  /** Minimum roll on the random loot table, or `null`. */
  get rollMin(): number | null { return (this._row.roll_min as number) ?? null }
  /** Maximum roll on the random loot table, or `null`. */
  get rollMax(): number | null { return (this._row.roll_max as number) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of typed mechanical effect objects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  toH() {
    return {
      id: this.id, name: this.name, categoria: this.categoria, preco: this.preco,
      roll_min: this.rollMin, roll_max: this.rollMax,
      description: this.description, effects: this.effects,
    }
  }

  static query(): Query<EsotericoMagico> { return BaseModel.makeQuery(TABLE, EsotericoMagico) }
  static all(): EsotericoMagico[] { return EsotericoMagico.query().all() }
  static find(id: string): EsotericoMagico | null { return EsotericoMagico.query().find(id) }
  static first(): EsotericoMagico | null { return EsotericoMagico.query().first() }
  static last(): EsotericoMagico | null { return EsotericoMagico.query().last() }
  static count(): number { return EsotericoMagico.query().count() }

  static menores(): Query<EsotericoMagico> { return EsotericoMagico.query().where("categoria = ?", "menor") }
  static medios(): Query<EsotericoMagico> { return EsotericoMagico.query().where("categoria = ?", "medio") }
  static maiores(): Query<EsotericoMagico> { return EsotericoMagico.query().where("categoria = ?", "maior") }
}
