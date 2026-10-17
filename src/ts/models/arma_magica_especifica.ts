import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "armas_magicas_especificas"

/**
 * A named specific magic weapon from Tormenta20 (Cap. 8, Tabela 8-9).
 *
 * @example
 * ```ts
 * ArmaMagicaEspecifica.all()
 * ArmaMagicaEspecifica.find("cajado_do_poder")
 * ArmaMagicaEspecifica.byBase("espada_longa").all()
 * ```
 */
export class ArmaMagicaEspecifica extends BaseModel {
  /** Base weapon type this item is built on (e.g. `"espada_longa"`). */
  get baseWeapon(): string | null { return (this._row.base_weapon as string) ?? null }
  /** Price in tibares. */
  get preco(): number | null { return (this._row.preco as number) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of mechanical effects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  toH() {
    return {
      id: this.id, name: this.name,
      base_weapon: this.baseWeapon, preco: this.preco,
      description: this.description, effects: this.effects,
    }
  }

  static query(): Query<ArmaMagicaEspecifica> { return BaseModel.makeQuery(TABLE, ArmaMagicaEspecifica) }
  static all(): ArmaMagicaEspecifica[] { return ArmaMagicaEspecifica.query().all() }
  static find(id: string): ArmaMagicaEspecifica | null { return ArmaMagicaEspecifica.query().find(id) }
  static first(): ArmaMagicaEspecifica | null { return ArmaMagicaEspecifica.query().first() }
  static last(): ArmaMagicaEspecifica | null { return ArmaMagicaEspecifica.query().last() }
  static count(): number { return ArmaMagicaEspecifica.query().count() }

  static byBase(weapon: string): Query<ArmaMagicaEspecifica> {
    return ArmaMagicaEspecifica.query().where("base_weapon = ?", weapon)
  }
}
