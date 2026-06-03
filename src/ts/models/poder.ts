import { BaseModel } from "./base.js"
import { Query } from "../query.js"
import { getBookReference, type BookReference } from "./concerns/book_referenceable.js"

const TABLE = "poderes"

/**
 * Valid power type identifiers.
 *
 * - `habilidade_unica_origem` — unique power granted by a character origin
 * - `poder_concedido` — power granted by a deity to a devotee
 * - `poder_tormenta` — corruption power from Tormenta exposure
 * - `poder_classe` — class feature power
 * - `habilidade_de_raca` — racial ability
 * - `poder_geral` — general power (feat)
 * - `poder_combate` — combat power
 * - `poder_destino` — destiny power
 * - `poder_magia` — magic power
 */
export type PoderType =
  | "habilidade_unica_origem" | "poder_concedido" | "poder_tormenta"
  | "poder_classe" | "habilidade_de_raca" | "poder_geral"
  | "poder_combate" | "poder_destino" | "poder_magia"

/**
 * A Poder (power or ability) in Tormenta20.
 *
 * Powers represent feats, class features, racial abilities, deity-granted
 * powers, and Tormenta corruption abilities.
 *
 * @example
 * ```ts
 * Poder.poderesCombate().all()          // all combat powers
 * Poder.byOrigin("nobre").all()         // powers from the Nobre origin
 * Poder.byDeity("khalmyr").all()        // powers granted by Khalmyr
 * Poder.find("arma_do_tempo")           // find by id
 * ```
 */
export class Poder extends BaseModel {
  get type(): PoderType { return this._row.type as PoderType }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of effect objects. Structure varies by type — see `PoderType` docs. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }
  /** JSON array of activation cost descriptors (PM costs, etc.). */
  get costs(): unknown[] { return BaseModel.json(this._row.costs, []) }
  /** JSON array of prerequisite descriptors. */
  get prerequisites(): unknown[] { return BaseModel.json(this._row.prerequisites, []) }
  /** ID of the associated {@link Origem}, or `null` for non-origin powers. */
  get originId(): string | null { return (this._row.origin_id as string) ?? null }
  /** ID of the associated {@link Classe}, or `null` for non-class powers. */
  get classId(): string | null { return (this._row.class_id as string) ?? null }
  /** IDs of deities that grant this power (for `poder_concedido`). */
  get deities(): string[] { return BaseModel.json(this._row.deities, []) }

  /** Returns the sourcebook page reference, or `null` if not indexed. */
  bookReference(): BookReference | null { return getBookReference(this.id) }

  toH() {
    return {
      id: this.id, name: this.name, type: this.type, description: this.description,
      effects: this.effects, costs: this.costs, prerequisites: this.prerequisites,
      origin_id: this.originId, class_id: this.classId, deities: this.deities,
    }
  }

  static query(): Query<Poder> { return BaseModel.makeQuery(TABLE, Poder) }
  static all(): Poder[] { return Poder.query().all() }
  static find(id: string): Poder | null { return Poder.query().find(id) }
  static first(): Poder | null { return Poder.query().first() }
  static last(): Poder | null { return Poder.query().last() }
  static count(): number { return Poder.query().count() }

  /** Returns powers matching the given type. */
  static byType(type: PoderType): Query<Poder> { return Poder.query().where("type = ?", type) }
  /** Returns powers associated with the given origin ID. */
  static byOrigin(originId: string): Query<Poder> { return Poder.query().where("origin_id = ?", originId) }
  /** Returns powers associated with the given class ID. */
  static byClass(classId: string): Query<Poder> { return Poder.query().where("class_id = ?", classId) }
  /** Returns powers granted by the given deity ID. */
  static byDeity(deityId: string): Query<Poder> { return Poder.query().where("deities LIKE ?", `%${deityId}%`) }

  static habilidadesUnicas(): Query<Poder> { return Poder.byType("habilidade_unica_origem") }
  static poderesConcedidos(): Query<Poder> { return Poder.byType("poder_concedido") }
  static poderesClasse(): Query<Poder> { return Poder.byType("poder_classe") }
  static poderesGerais(): Query<Poder> { return Poder.byType("poder_geral") }
  static habilidadesDeRaca(): Query<Poder> { return Poder.byType("habilidade_de_raca") }
  static poderesTormenta(): Query<Poder> { return Poder.byType("poder_tormenta") }
  static poderesCombate(): Query<Poder> { return Poder.byType("poder_combate") }
  static poderesDestino(): Query<Poder> { return Poder.byType("poder_destino") }
  static poderesMagia(): Query<Poder> { return Poder.byType("poder_magia") }
}
