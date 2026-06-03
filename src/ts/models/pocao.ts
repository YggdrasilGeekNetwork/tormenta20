import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "pocoes"

/**
 * A Poção (potion), Óleo (oil), or Granada (grenade) in Tormenta20.
 *
 * These are consumable magical items that replicate spell effects.
 *
 * @example
 * ```ts
 * Pocao.pocoes().all()
 * Pocao.oleos().all()
 * Pocao.granadas().all()
 * Pocao.menores().all()
 * Pocao.find("pocao_de_cura_menor")
 * ```
 */
export class Pocao extends BaseModel {
  /** `"pocao"`, `"oleo"`, or `"granada"`. */
  get subtipo(): string { return this._row.subtipo as string }
  /** ID of the spell this item replicates. */
  get spellId(): string { return this._row.spell_id as string }
  /** PM cost of the replicated spell effect. */
  get pmCost(): number { return this._row.pm_cost as number }
  /** Power tier: `"menor"`, `"media"`, or `"maior"`. */
  get categoria(): string { return this._row.categoria as string }
  /** Price in tibares. */
  get preco(): number { return (this._row.preco as number) ?? 0 }
  /** Minimum roll on the random loot table, or `null`. */
  get rollMin(): number | null { return (this._row.roll_min as number) ?? null }
  /** Maximum roll on the random loot table, or `null`. */
  get rollMax(): number | null { return (this._row.roll_max as number) ?? null }
  /** Enhancement level identifier, or `null`. */
  get aprimoramento(): string | null { return (this._row.aprimoramento as string) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }

  toH() {
    return {
      id: this.id, name: this.name, subtipo: this.subtipo, spell_id: this.spellId,
      pm_cost: this.pmCost, categoria: this.categoria, preco: this.preco,
      roll_min: this.rollMin, roll_max: this.rollMax,
      aprimoramento: this.aprimoramento, description: this.description,
    }
  }

  static query(): Query<Pocao> { return BaseModel.makeQuery(TABLE, Pocao) }
  static all(): Pocao[] { return Pocao.query().all() }
  static find(id: string): Pocao | null { return Pocao.query().find(id) }
  static first(): Pocao | null { return Pocao.query().first() }
  static last(): Pocao | null { return Pocao.query().last() }
  static count(): number { return Pocao.query().count() }

  static menores(): Query<Pocao> { return Pocao.query().where("categoria = ?", "menor") }
  static medias(): Query<Pocao> { return Pocao.query().where("categoria = ?", "media") }
  static maiores(): Query<Pocao> { return Pocao.query().where("categoria = ?", "maior") }
  static pocoes(): Query<Pocao> { return Pocao.query().where("subtipo = ?", "pocao") }
  static oleos(): Query<Pocao> { return Pocao.query().where("subtipo = ?", "oleo") }
  static granadas(): Query<Pocao> { return Pocao.query().where("subtipo = ?", "granada") }
}
