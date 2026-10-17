import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "itens_liturgicos"

export type ItemLiturgicoSubtipo = "arma" | "armadura" | "acessorio"

/**
 * A named magic item tied to a specific deity (Deuses de Arton, Cap. 1).
 *
 * Liturgical items only reach their full potential — or only work at all —
 * in the hands of a devotee of the associated deity.
 *
 * @example
 * ```ts
 * ItemLiturgico.all()
 * ItemLiturgico.byDeity("aharadak").all()
 * ItemLiturgico.find("cilicio_vivo")
 * ```
 */
export class ItemLiturgico extends BaseModel {
  /** IDs of deities associated with this item. */
  get deities(): string[] { return BaseModel.json(this._row.deities, []) }
  /** `"arma"`, `"armadura"` or `"acessorio"`. */
  get subtipo(): ItemLiturgicoSubtipo | null { return (this._row.subtipo as ItemLiturgicoSubtipo) ?? null }
  /** Base item this is built on, when applicable (e.g. `"machado_de_guerra"`). */
  get baseItem(): string | null { return (this._row.base_item as string) ?? null }
  /** Raw tier tag from the book (e.g. `"Arma específica menor"`, `"Acessório maior"`). */
  get classificacao(): string | null { return (this._row.classificacao as string) ?? null }
  /** Price in tibares. */
  get preco(): number | null { return (this._row.preco as number) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** JSON array of mechanical effects. */
  get effects(): unknown[] { return BaseModel.json(this._row.effects, []) }

  toH() {
    return {
      id: this.id, name: this.name, deities: this.deities,
      subtipo: this.subtipo, base_item: this.baseItem,
      classificacao: this.classificacao, preco: this.preco,
      description: this.description, effects: this.effects,
    }
  }

  static query(): Query<ItemLiturgico> { return BaseModel.makeQuery(TABLE, ItemLiturgico) }
  static all(): ItemLiturgico[] { return ItemLiturgico.query().all() }
  static find(id: string): ItemLiturgico | null { return ItemLiturgico.query().find(id) }
  static first(): ItemLiturgico | null { return ItemLiturgico.query().first() }
  static last(): ItemLiturgico | null { return ItemLiturgico.query().last() }
  static count(): number { return ItemLiturgico.query().count() }

  static byDeity(deityId: string): Query<ItemLiturgico> {
    return ItemLiturgico.query().where("deities LIKE ?", `%${deityId}%`)
  }

  static bySubtipo(subtipo: ItemLiturgicoSubtipo): Query<ItemLiturgico> {
    return ItemLiturgico.query().where("subtipo = ?", subtipo)
  }
}
