import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "classes"

/**
 * A Classe (character class) in Tormenta20.
 *
 * @example
 * ```ts
 * Classe.all()                    // all classes
 * Classe.conjuradores().all()     // spellcasting classes only
 * Classe.find("guerreiro")
 *
 * const guerreiro = Classe.find("guerreiro")!
 * guerreiro.initialHp             // 20
 * guerreiro.hpPerLevel            // 5
 * guerreiro.isConjurador          // false
 * ```
 */
export class Classe extends BaseModel {
  /** Raw hit_points JSON object with `initial` and `per_level` keys. */
  get hitPoints(): Record<string, number> { return BaseModel.json(this._row.hit_points, { initial: 0, per_level: 0 }) }
  /** Raw mana_points JSON object with `per_level` key. */
  get manaPoints(): Record<string, number> { return BaseModel.json(this._row.mana_points, { per_level: 0 }) }
  /** Raw skills JSON with `mandatory`, `choose_amount`, and `choose_from` keys. */
  get skills(): Record<string, unknown> { return BaseModel.json(this._row.skills, {}) }
  /** Raw proficiencies JSON with `weapons`, `armors`, and `shields` keys. */
  get proficiencies(): Record<string, unknown> { return BaseModel.json(this._row.proficiencies, {}) }
  /** Class ability objects (level-up features). */
  get abilities(): unknown[] { return BaseModel.json(this._row.abilities, []) }
  /** Class power unlocks by level. */
  get powers(): unknown[] { return BaseModel.json(this._row.powers, []) }
  /** Level-by-level progression table rows. */
  get progression(): unknown[] { return BaseModel.json(this._row.progression, []) }
  /**
   * Spellcasting data (attribute, circle progression, etc.), or `null` for non-casters.
   *
   * Check {@link isConjurador} for a boolean shortcut.
   */
  get spellcasting(): Record<string, unknown> | null {
    const v = BaseModel.json<Record<string, unknown> | null>(this._row.spellcasting, null)
    return v && Object.keys(v).length > 0 ? v : null
  }

  /** HP at level 1. */
  get initialHp(): number { return this.hitPoints.initial ?? 0 }
  /** HP gained per level. */
  get hpPerLevel(): number { return this.hitPoints.per_level ?? 0 }
  /** MP gained per level. */
  get mpPerLevel(): number { return this.manaPoints.per_level ?? 0 }
  /** Skills all members of this class are trained in. */
  get mandatorySkills(): unknown[] { return (this.skills.mandatory as unknown[]) ?? [] }
  /** Number of skills the player may choose at character creation. */
  get chooseSkillsAmount(): number { return (this.skills.choose_amount as number) ?? 0 }
  /** Pool of skills the player chooses from. */
  get availableSkills(): unknown[] { return (this.skills.choose_from as unknown[]) ?? [] }
  /** Weapon category proficiencies (e.g. `["simples", "marciais"]`). */
  get weaponProficiencies(): string[] { return (this.proficiencies.weapons as string[]) ?? [] }
  /** Armor category proficiencies (e.g. `["leves"]`). */
  get armorProficiencies(): string[] { return (this.proficiencies.armors as string[]) ?? [] }
  /** Whether the class is proficient with shields. */
  get shieldProficiency(): boolean { return !!(this.proficiencies.shields) }
  /** `true` if the class can cast spells (has non-empty spellcasting data). */
  get isConjurador(): boolean { return this.spellcasting !== null }

  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, hit_points: this.hitPoints, mana_points: this.manaPoints,
      skills: this.skills, proficiencies: this.proficiencies, abilities: this.abilities,
      powers: this.powers, progression: this.progression, spellcasting: this.spellcasting,
    }
  }

  static query(): Query<Classe> { return BaseModel.makeQuery(TABLE, Classe) }
  static all(): Classe[] { return Classe.query().all() }
  static find(id: string): Classe | null { return Classe.query().find(id) }
  static first(): Classe | null { return Classe.query().first() }
  static last(): Classe | null { return Classe.query().last() }
  static count(): number { return Classe.query().count() }
  /** Returns only classes that have spellcasting capability. */
  static conjuradores(): Query<Classe> { return Classe.query().where("spellcasting IS NOT NULL AND spellcasting != '{}'") }
}
