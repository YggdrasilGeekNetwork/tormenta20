import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "classes_variantes"

/**
 * A Classe Variante (variant class) in Tormenta20.
 *
 * A specialized version of a base class (e.g. Duelista is a Bucaneiro
 * variant). Stored as a diff over the base class: `diffs` lists, per
 * level, which base-class abilities are removed and which new ones are
 * added. Consumers must resolve the diff against the base {@link Classe}
 * record to build the final character sheet.
 *
 * @example
 * ```ts
 * const variante = ClasseVariante.find("duelista")
 * Classe.find(variante.baseClassId)  // the Bucaneiro Classe record
 * variante.diffs  // [{ nivel: 1, remove: [...], adiciona: [...] }, ...]
 * ```
 */
export class ClasseVariante extends BaseModel {
  /** ID of the base {@link Classe} this variant specializes. */
  get baseClassId(): string { return this._row.base_class_id as string }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of per-level diffs against the base class: `{ nivel, remove, adiciona }`. */
  get diffs(): unknown[] { return BaseModel.json(this._row.diffs, []) }

  toH() {
    return {
      id: this.id, name: this.name, base_class_id: this.baseClassId,
      description: this.description, diffs: this.diffs,
    }
  }

  static query(): Query<ClasseVariante> { return BaseModel.makeQuery(TABLE, ClasseVariante) }
  static all(): ClasseVariante[] { return ClasseVariante.query().all() }
  static find(id: string): ClasseVariante | null { return ClasseVariante.query().find(id) }
  static first(): ClasseVariante | null { return ClasseVariante.query().first() }
  static last(): ClasseVariante | null { return ClasseVariante.query().last() }
  static count(): number { return ClasseVariante.query().count() }

  /** Returns variant classes built on the given base class ID. */
  static byBase(classId: string): Query<ClasseVariante> {
    return ClasseVariante.query().where("base_class_id = ?", classId)
  }
}
