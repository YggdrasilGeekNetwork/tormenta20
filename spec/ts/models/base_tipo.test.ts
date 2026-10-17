import { describe, it, expect } from "vitest"
import { BaseTipo } from "../../../src/ts/models/base_tipo.js"

describe("BaseTipo", () => {
  it("has the 6 base types loaded", () => {
    expect(BaseTipo.count()).toBe(6)
  })

  it("each tipo has id, name, description and non-empty effects", () => {
    for (const t of BaseTipo.all()) {
      expect(t.id).toBeTruthy()
      expect(t.name).toBeTruthy()
      expect(t.description).toBeTruthy()
      expect(Array.isArray(t.effects)).toBe(true)
      expect(t.effects.length).toBeGreaterThan(0)
    }
  })

  it("includes the 6 named types from the book", () => {
    const ids = BaseTipo.all().map((t) => t.id).sort()
    expect(ids).toEqual(
      ["centro_de_poder", "empreendimento", "esconderijo", "fortificacao", "movel", "residencia"].sort()
    )
  })

  it("toH returns a plain object with effects", () => {
    const tipo = BaseTipo.find("fortificacao")!
    const h = tipo.toH()
    expect(h.id).toBe("fortificacao")
    expect(Array.isArray(h.effects)).toBe(true)
  })
})
