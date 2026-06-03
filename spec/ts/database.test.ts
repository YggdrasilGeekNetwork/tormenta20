import { describe, it, expect, afterEach } from "vitest"
import { database } from "../../src/ts/database.js"

describe("database", () => {
  afterEach(() => {
    database.disconnect()
  })

  it("connects lazily on first db access", () => {
    expect(database.connected).toBe(false)
    void database.db
    expect(database.connected).toBe(true)
  })

  it("returns the same connection on repeated access", () => {
    const a = database.db
    const b = database.db
    expect(a).toBe(b)
  })

  it("reconnects after disconnect", () => {
    void database.db
    database.disconnect()
    expect(database.connected).toBe(false)
    void database.db
    expect(database.connected).toBe(true)
  })

  it("defaults to built_in mode", () => {
    expect(database.mode).toBe("built_in")
  })

  it("uses TORMENTA20_DB_MODE env var", () => {
    process.env.TORMENTA20_DB_MODE = "path"
    expect(database.mode).toBe("path")
    delete process.env.TORMENTA20_DB_MODE
  })
})
