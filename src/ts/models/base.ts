import { Query } from "../query.js"

/**
 * Abstract base class for all Tormenta20 models.
 *
 * Wraps a raw SQLite row and exposes typed getters. Every concrete model
 * inherits `id`, `name`, `createdAt`, and `updatedAt`, and must implement
 * `toH()` to return a plain-object representation.
 *
 * @abstract
 */
export abstract class BaseModel {
  constructor(protected readonly _row: Record<string, unknown>) {}

  /** Unique string identifier (e.g. `"espada_longa"`, `"guerreiro"`). */
  get id(): string { return this._row.id as string }

  /** Display name. */
  get name(): string { return this._row.name as string }

  /** ISO 8601 timestamp of record creation. */
  get createdAt(): string { return this._row.created_at as string }

  /** ISO 8601 timestamp of last update. */
  get updatedAt(): string { return this._row.updated_at as string }

  /** Returns a plain-object representation of this record. */
  abstract toH(): Record<string, unknown>

  /**
   * Parses a JSON column value, returning `fallback` on null or parse error.
   *
   * @internal
   */
  protected static json<T>(val: unknown, fallback: T): T {
    if (val === null || val === undefined) return fallback
    if (typeof val === "string") {
      try { return JSON.parse(val) as T } catch { return fallback }
    }
    return val as T
  }

  /**
   * Coerces SQLite's integer booleans (`0`/`1`) and string booleans to `boolean`.
   *
   * @internal
   */
  protected static bool(val: unknown): boolean {
    return val === 1 || val === true || val === "true"
  }

  /** @internal */
  protected static makeQuery<T>(
    table: string,
    ctor: new (row: Record<string, unknown>) => T
  ): Query<T> {
    return new Query<T>(table, (row) => new ctor(row))
  }
}
