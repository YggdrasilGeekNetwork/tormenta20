import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "divindades"

/** The type of divine energy a deity channels (affects cleric turning ability). */
export type DivindadeEnergy = "positiva" | "negativa" | "qualquer"

/**
 * A Divindade (deity) in Tormenta20.
 *
 * @example
 * ```ts
 * Divindade.all()
 * Divindade.energiaPositiva().all()
 * Divindade.find("khalmyr")
 *
 * const khalmyr = Divindade.find("khalmyr")!
 * khalmyr.grantedPowers    // ["poder_id", ...]
 * khalmyr.races()          // races that worship Khalmyr
 * khalmyr.classes()        // classes that worship Khalmyr
 * ```
 */
export class Divindade extends BaseModel {
  /** Deity title or epithet (e.g. `"O Senhor da Justiça"`), or `null`. */
  get title(): string | null { return (this._row.title as string) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** Beliefs and objectives of the deity's faith. */
  get beliefsObjectives(): unknown[] { return BaseModel.json(this._row.beliefs_objectives, []) }
  get holySymbol(): string | null { return (this._row.holy_symbol as string) ?? null }
  get energy(): DivindadeEnergy { return this._row.energy as DivindadeEnergy }
  /** ID of the deity's preferred weapon, or `null`. */
  get preferredWeapon(): string | null { return (this._row.preferred_weapon as string) ?? null }
  /** Raw devotees object with `races` and `classes` arrays. */
  get devotees(): Record<string, unknown> { return BaseModel.json(this._row.devotees, {}) }
  /** IDs of powers granted to devoted characters. */
  get grantedPowers(): string[] { return BaseModel.json(this._row.granted_powers, []) }
  get obligationsRestrictions(): string | null { return (this._row.obligations_restrictions as string) ?? null }

  /** Returns race IDs whose members commonly worship this deity. */
  races(): string[] { return (this.devotees.races as string[]) ?? [] }
  /** Returns class IDs whose members commonly worship this deity. */
  classes(): string[] { return (this.devotees.classes as string[]) ?? [] }
  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, title: this.title, description: this.description,
      beliefs_objectives: this.beliefsObjectives, holy_symbol: this.holySymbol,
      energy: this.energy, preferred_weapon: this.preferredWeapon,
      devotees: this.devotees, granted_powers: this.grantedPowers,
      obligations_restrictions: this.obligationsRestrictions,
    }
  }

  static query(): Query<Divindade> { return BaseModel.makeQuery(TABLE, Divindade) }
  static all(): Divindade[] { return Divindade.query().all() }
  static find(id: string): Divindade | null { return Divindade.query().find(id) }
  static first(): Divindade | null { return Divindade.query().first() }
  static last(): Divindade | null { return Divindade.query().last() }
  static count(): number { return Divindade.query().count() }

  static byEnergy(energy: DivindadeEnergy): Query<Divindade> { return Divindade.query().where("energy = ?", energy) }
  /** Returns deities that channel positive energy. */
  static energiaPositiva(): Query<Divindade> { return Divindade.byEnergy("positiva") }
  /** Returns deities that channel negative energy. */
  static energiaNegativa(): Query<Divindade> { return Divindade.byEnergy("negativa") }
  /** Returns deities that can channel either energy type. */
  static energiaQualquer(): Query<Divindade> { return Divindade.byEnergy("qualquer") }
}
