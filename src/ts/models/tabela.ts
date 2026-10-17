import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "tabelas"

/**
 * A Tabela (reference table) in Tormenta20.
 *
 * Tables store structured tabular data from T20 sourcebooks (e.g. random loot tables,
 * encounter tables, etc.).
 *
 * @example
 * ```ts
 * Tabela.all()
 * Tabela.find("tesouros_por_nd")
 *
 * const t = Tabela.find("tesouros_por_nd")!
 * t.headers   // ["ND", "Tibares", "Itens"]
 * t.rows      // [{ "ND": "1", "Tibares": "50", "Itens": "—" }, ...]
 * ```
 */
export class Tabela extends BaseModel {
  get description(): string | null { return (this._row.description as string) ?? null }
  /** Column header labels. */
  get headers(): string[] { return BaseModel.json(this._row.headers, []) }
  /** Array of rows, each an object keyed by header. */
  get rows(): Record<string, unknown>[] { return BaseModel.json(this._row.rows, []) }
  /** Dice expression (e.g. `"1d100"`), if this table is rollable. */
  get dice(): string | null { return (this._row.dice as string) ?? null }

  /** True if this table has a `dice` value and can be rolled on. */
  get sorteavel(): boolean { return this.dice != null }

  /**
   * Rolls the table's dice and returns the matching row (same shape as {@link rows}
   * entries). Assumes the first header's column holds a range string (e.g. `"01-05"`)
   * or a single value (e.g. `"06"`) that the roll falls within.
   */
  roll(): Record<string, unknown> | null {
    if (!this.dice) throw new Error(`Tabela '${this.id}' não é sorteável (sem campo dice)`)

    const faces = parseInt(this.dice.match(/\d+$/)?.[0] ?? "0", 10)
    const result = Math.floor(Math.random() * faces) + 1
    const rangeKey = this.headers[0]
    return this.rows.find((r) => Tabela.inRange(String(r[rangeKey]), result)) ?? null
  }

  private static inRange(rangeStr: string, value: number): boolean {
    const bounds = rangeStr.split("-").map((s) => parseInt(s, 10))
    const lo = Math.min(...bounds)
    const hi = Math.max(...bounds)
    return value >= lo && value <= hi
  }

  toH() {
    return {
      id: this.id, name: this.name, description: this.description,
      headers: this.headers, rows: this.rows, dice: this.dice,
    }
  }

  static query(): Query<Tabela> { return BaseModel.makeQuery(TABLE, Tabela) }
  static all(): Tabela[] { return Tabela.query().all() }
  static find(id: string): Tabela | null { return Tabela.query().find(id) }
  static first(): Tabela | null { return Tabela.query().first() }
  static last(): Tabela | null { return Tabela.query().last() }
  static count(): number { return Tabela.query().count() }
}
