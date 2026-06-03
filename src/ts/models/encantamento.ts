import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "encantamentos"

/** Whether the enchantment applies to weapons or to armors/shields. */
export type EncantamentoCategoria = "arma" | "armadura"

/**
 * An Encantamento (magical enchantment) that can be applied to weapons or armor/shields.
 *
 * @example
 * ```ts
 * Encantamento.armas().all()
 * Encantamento.armadurasEscudos().all()
 * Encantamento.escudoOnly().all()
 * Encantamento.find("afiado")
 * ```
 */
export class Encantamento extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  get categoria(): EncantamentoCategoria { return this._row.categoria as EncantamentoCategoria }
  /** `true` if this enchantment can only be applied to shields (not regular armors). */
  get escudoOnly(): boolean { return BaseModel.bool(this._row.escudo_only) }
  /** `true` if this enchantment counts as two enchantment slots. */
  get contaComoDois(): boolean { return BaseModel.bool(this._row.conta_como_dois) }
  /** JSON array of prerequisite descriptors. */
  get prerequisitos(): unknown[] { return BaseModel.json(this._row.prerequisitos, []) }
  /** JSON object with mechanical effects. */
  get efeito(): Record<string, unknown> { return BaseModel.json(this._row.efeito, {}) }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description, categoria: this.categoria,
      escudo_only: this.escudoOnly, conta_como_dois: this.contaComoDois,
      prerequisitos: this.prerequisitos, efeito: this.efeito,
    }
  }

  static query(): Query<Encantamento> { return BaseModel.makeQuery(TABLE, Encantamento) }
  static all(): Encantamento[] { return Encantamento.query().all() }
  static find(id: string): Encantamento | null { return Encantamento.query().find(id) }
  static first(): Encantamento | null { return Encantamento.query().first() }
  static last(): Encantamento | null { return Encantamento.query().last() }
  static count(): number { return Encantamento.query().count() }

  /** Returns enchantments that apply to weapons. */
  static armas(): Query<Encantamento> { return Encantamento.query().where("categoria = ?", "arma") }
  /** Returns enchantments that apply to armors and shields. */
  static armadurasEscudos(): Query<Encantamento> { return Encantamento.query().where("categoria = ?", "armadura") }
  /** Returns armor/shield enchantments applicable only to shields. */
  static escudoOnly(): Query<Encantamento> { return Encantamento.query().where("escudo_only = 1") }
}
