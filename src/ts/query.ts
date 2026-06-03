import { database } from "./database.js"

/**
 * Immutable chainable query builder over a SQLite table.
 *
 * Every method that filters or sorts returns a **new** `Query` instance,
 * so the original is never mutated. Call a terminal method (`all`, `first`,
 * `last`, `find`, `count`, `exists`) to execute the query.
 *
 * @typeParam T - The model class this query resolves to.
 *
 * @example
 * ```ts
 * Arma.query()
 *   .where("category = ?", "marciais")
 *   .order("name")
 *   .limit(10)
 *   .all()
 * ```
 */
export class Query<T> {
  private readonly wheres: string[]
  private readonly params: unknown[]
  private readonly _order: string | null
  private readonly _limit: number | null

  constructor(
    private readonly table: string,
    private readonly deserialize: (row: Record<string, unknown>) => T,
    wheres: string[] = [],
    params: unknown[] = [],
    order: string | null = null,
    limit: number | null = null
  ) {
    this.wheres = wheres
    this.params = params
    this._order = order
    this._limit = limit
  }

  private clone(patch: Partial<{ wheres: string[]; params: unknown[]; order: string | null; limit: number | null }>): Query<T> {
    return new Query(
      this.table,
      this.deserialize,
      patch.wheres ?? this.wheres,
      patch.params ?? this.params,
      patch.order !== undefined ? patch.order : this._order,
      patch.limit !== undefined ? patch.limit : this._limit
    )
  }

  /**
   * Adds a `WHERE` clause using a parameterised SQL fragment.
   *
   * Multiple calls are combined with `AND`.
   *
   * @param sql - SQL fragment with `?` placeholders (e.g. `"category = ?"`)
   * @param p - Values bound to each `?` in order
   * @returns A new `Query` with the clause appended
   *
   * @example
   * ```ts
   * Magia.query().where("circle = ?", "3").where("type = ?", "arcana").all()
   * ```
   */
  where(sql: string, ...p: unknown[]): Query<T> {
    return this.clone({ wheres: [...this.wheres, sql], params: [...this.params, ...p] })
  }

  /**
   * Sets the `ORDER BY` clause.
   *
   * @param field - Column name to sort by
   * @param dir - Sort direction (default `"ASC"`)
   * @returns A new `Query` with the ordering applied
   */
  order(field: string, dir: "ASC" | "DESC" = "ASC"): Query<T> {
    return this.clone({ order: `${field} ${dir}` })
  }

  /**
   * Sets a `LIMIT` on the number of rows returned.
   *
   * @param n - Maximum number of results
   * @returns A new `Query` with the limit applied
   */
  limit(n: number): Query<T> {
    return this.clone({ limit: n })
  }

  private get whereSql(): string {
    return this.wheres.length > 0 ? ` WHERE ${this.wheres.join(" AND ")}` : ""
  }

  private get orderSql(): string {
    return this._order ? ` ORDER BY ${this._order}` : ""
  }

  private get limitSql(): string {
    return this._limit !== null ? ` LIMIT ${this._limit}` : ""
  }

  /**
   * Executes the query and returns all matching records.
   *
   * @returns Array of model instances (empty array if none found)
   */
  all(): T[] {
    const sql = `SELECT * FROM ${this.table}${this.whereSql}${this.orderSql}${this.limitSql}`
    const rows = database.db.prepare(sql).all(...this.params) as Record<string, unknown>[]
    return rows.map(this.deserialize)
  }

  /**
   * Returns the first record by insertion order, or `null` if none found.
   */
  first(): T | null {
    const sql = `SELECT * FROM ${this.table}${this.whereSql} ORDER BY rowid ASC LIMIT 1`
    const row = database.db.prepare(sql).get(...this.params) as Record<string, unknown> | undefined
    return row ? this.deserialize(row) : null
  }

  /**
   * Returns the last record by insertion order, or `null` if none found.
   */
  last(): T | null {
    const sql = `SELECT * FROM ${this.table}${this.whereSql} ORDER BY rowid DESC LIMIT 1`
    const row = database.db.prepare(sql).get(...this.params) as Record<string, unknown> | undefined
    return row ? this.deserialize(row) : null
  }

  /**
   * Looks up a single record by its `id` column.
   *
   * @param id - The unique string identifier
   * @returns The matching record, or `null` if not found
   */
  find(id: string): T | null {
    const sql = `SELECT * FROM ${this.table} WHERE id = ?`
    const row = database.db.prepare(sql).get(id) as Record<string, unknown> | undefined
    return row ? this.deserialize(row) : null
  }

  /**
   * Counts the rows matching the current filters.
   *
   * @returns Number of matching records
   */
  count(): number {
    const sql = `SELECT COUNT(*) as n FROM ${this.table}${this.whereSql}`
    const row = database.db.prepare(sql).get(...this.params) as { n: number }
    return row.n
  }

  /**
   * Returns `true` if at least one record matches the current filters.
   */
  exists(): boolean {
    return this.count() > 0
  }
}
