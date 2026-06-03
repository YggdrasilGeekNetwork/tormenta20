import Database from "better-sqlite3"
import { join, dirname, resolve } from "path"
import { fileURLToPath } from "url"
import { existsSync } from "fs"

const __dirname = dirname(fileURLToPath(import.meta.url))

function findPackageRoot(): string {
  // Resolves correctly whether called from src/ts/ (dev/test) or dist/ (compiled).
  // Checks for the db/ directory (committed) rather than the sqlite file (gitignored).
  for (const rel of ["../../", "../"]) {
    const candidate = resolve(__dirname, rel)
    if (existsSync(join(candidate, "db"))) return candidate
  }
  throw new Error(`Cannot locate tormenta20 package root from: ${__dirname}`)
}

/**
 * Controls which SQLite database file is used.
 *
 * - `built_in` — ships inside the gem package (default)
 * - `create_on_build` — creates/seeds a new DB at build time (used by the seeder)
 * - `path` — reads from `TORMENTA20_DB_PATH` env var
 */
export type DbMode = "built_in" | "create_on_build" | "path"

/**
 * Manages the SQLite connection used by all models.
 *
 * Configured via environment variables:
 * - `TORMENTA20_DB_MODE`: `"built_in"` (default), `"create_on_build"`, or `"path"`
 * - `TORMENTA20_DB_PATH`: required when mode is `"path"`
 *
 * @example
 * ```ts
 * import { database } from "tormenta20"
 * database.setup() // explicit init; models call this lazily
 * ```
 * @internal
 */
class Tormenta20Database {
  private _db: Database.Database | null = null

  get mode(): DbMode {
    return (process.env.TORMENTA20_DB_MODE as DbMode) ?? "built_in"
  }

  get defaultDbPath(): string {
    return join(findPackageRoot(), "db", "tormenta20.sqlite3")
  }

  get schemaPath(): string {
    return join(findPackageRoot(), "db", "schema.sql")
  }

  get dbPath(): string {
    if (this.mode === "path") {
      const p = process.env.TORMENTA20_DB_PATH
      if (!p) throw new Error("TORMENTA20_DB_PATH is not set")
      return p
    }
    return this.defaultDbPath
  }

  setup(): void {
    const readonly = this.mode !== "create_on_build"
    this._db = new Database(this.dbPath, { readonly })
    this._db.pragma("journal_mode = WAL")
    this._db.pragma("foreign_keys = ON")
  }

  ensureConnected(): void {
    if (!this._db || !this._db.open) this.setup()
  }

  get db(): Database.Database {
    this.ensureConnected()
    return this._db!
  }

  get connected(): boolean {
    return this._db !== null && this._db.open
  }

  disconnect(): void {
    this._db?.close()
    this._db = null
  }

  reset(): void {
    this.disconnect()
    this.setup()
  }
}

export const database = new Tormenta20Database()
