import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "armaduras_magicas_especificas"

export type ArmaduraMagicaSubtipo = "armadura" | "escudo"

/**
 * A named specific magic armor or shield from Tormenta20 (Cap. 8, Tabela 8-11).
 *
 * @example
 * ```ts
 * ArmaduraMagicaEspecifica.all()
 * ArmaduraMagicaEspecifica.armaduras().all()
 * ArmaduraMagicaEspecifica.escudos().all()
 * ArmaduraMagicaEspecifica.find("cota_elfica")
 * ```
 */
export class ArmaduraMagicaEspecifica extends BaseModel {
  /** `"armadura"` or `"escudo"`. */
  get subtipo(): ArmaduraMagicaSubtipo { return this._row.subtipo as ArmaduraMagicaSubtipo }
  /** Base item this is built on (e.g. `"cota_de_malha"`). */
  get baseItem(): string | null { return (this._row.base_item as string) ?? null }
  /** Price in tibares. */
  get preco(): number | null { return (this._row.preco as number) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of mechanical effects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  toH() {
    return {
      id: this.id, name: this.name, subtipo: this.subtipo,
      base_item: this.baseItem, preco: this.preco,
      description: this.description, effects: this.effects,
    }
  }

  static query(): Query<ArmaduraMagicaEspecifica> { return BaseModel.makeQuery(TABLE, ArmaduraMagicaEspecifica) }
  static all(): ArmaduraMagicaEspecifica[] { return ArmaduraMagicaEspecifica.query().all() }
  static find(id: string): ArmaduraMagicaEspecifica | null { return ArmaduraMagicaEspecifica.query().find(id) }
  static first(): ArmaduraMagicaEspecifica | null { return ArmaduraMagicaEspecifica.query().first() }
  static last(): ArmaduraMagicaEspecifica | null { return ArmaduraMagicaEspecifica.query().last() }
  static count(): number { return ArmaduraMagicaEspecifica.query().count() }

  static armaduras(): Query<ArmaduraMagicaEspecifica> {
    return ArmaduraMagicaEspecifica.query().where("subtipo = ?", "armadura")
  }

  static escudos(): Query<ArmaduraMagicaEspecifica> {
    return ArmaduraMagicaEspecifica.query().where("subtipo = ?", "escudo")
  }
}
