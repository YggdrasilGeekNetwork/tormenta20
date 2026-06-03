import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "pericias"

/** The governing attribute abbreviation for a skill. */
export type PericiaAtributo = "FOR" | "DES" | "CON" | "INT" | "SAB" | "CAR"

/**
 * A Perícia (skill) in Tormenta20.
 *
 * @example
 * ```ts
 * Pericia.all()
 * Pericia.trainedOnlySkills().all()
 * Pericia.byAtributo("CAR").all()
 * Pericia.find("diplomacia")
 * ```
 */
export class Pericia extends BaseModel {
  /** Governing attribute (e.g. `"CAR"` for Diplomacia). */
  get atributo(): PericiaAtributo { return this._row.atributo as PericiaAtributo }
  /** `true` if the character must be trained to use this skill. */
  get trainedOnly(): boolean { return BaseModel.bool(this._row.trained_only) }
  /** `true` if armor penalty applies to rolls using this skill. */
  get armorPenalty(): boolean { return BaseModel.bool(this._row.armor_penalty) }
  /** `true` if this skill is used as a saving throw (resistência). */
  get resistanceSkill(): boolean { return BaseModel.bool(this._row.resistance_skill) }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of use-case descriptors. */
  get uses(): unknown[] { return BaseModel.json(this._row.uses, []) }

  toH() {
    return {
      id: this.id, name: this.name, atributo: this.atributo,
      trained_only: this.trainedOnly, armor_penalty: this.armorPenalty,
      resistance_skill: this.resistanceSkill, description: this.description, uses: this.uses,
    }
  }

  static query(): Query<Pericia> { return BaseModel.makeQuery(TABLE, Pericia) }
  static all(): Pericia[] { return Pericia.query().all() }
  static find(id: string): Pericia | null { return Pericia.query().find(id) }
  static first(): Pericia | null { return Pericia.query().first() }
  static last(): Pericia | null { return Pericia.query().last() }
  static count(): number { return Pericia.query().count() }

  /** Returns skills governed by the given attribute. */
  static byAtributo(attr: PericiaAtributo): Query<Pericia> { return Pericia.query().where("atributo = ?", attr) }
  /** Returns skills that require training to use. */
  static trainedOnlySkills(): Query<Pericia> { return Pericia.query().where("trained_only = 1") }
  /** Returns skills affected by armor penalty. */
  static withArmorPenalty(): Query<Pericia> { return Pericia.query().where("armor_penalty = 1") }
  /** Returns skills used as saving throws. */
  static resistanceSkills(): Query<Pericia> { return Pericia.query().where("resistance_skill = 1") }
}
