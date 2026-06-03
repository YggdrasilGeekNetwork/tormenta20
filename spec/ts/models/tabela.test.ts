import { describe, it, expect } from "vitest"
import { Tabela } from "../../../src/ts/models/tabela.js"

describe("Tabela", () => {
  it("has tabelas loaded", () => {
    expect(Tabela.count()).toBeGreaterThan(0)
  })

  it("headers and rows are arrays", () => {
    for (const t of Tabela.all()) {
      expect(Array.isArray(t.headers)).toBe(true)
      expect(Array.isArray(t.rows)).toBe(true)
    }
  })

  it("toH returns headers and rows", () => {
    const t = Tabela.first()!
    const h = t.toH()
    expect(h).toMatchObject({ id: t.id, name: t.name })
    expect(Array.isArray(h.headers)).toBe(true)
    expect(Array.isArray(h.rows)).toBe(true)
  })
})
