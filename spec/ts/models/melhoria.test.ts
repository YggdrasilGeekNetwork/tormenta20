import { describe, it, expect } from "vitest"
import { Melhoria } from "../../../src/ts/models/melhoria.js"

describe("Melhoria", () => {
  it("has melhorias loaded", () => {
    expect(Melhoria.count()).toBeGreaterThan(0)
  })

  it("every melhoria has id and name", () => {
    for (const m of Melhoria.all()) {
      expect(m.id).toBeTruthy()
      expect(m.name).toBeTruthy()
    }
  })

  it("every melhoria has a non-empty effects array of typed objects", () => {
    for (const m of Melhoria.all()) {
      expect(Array.isArray(m.effects)).toBe(true)
      expect(m.effects.length).toBeGreaterThan(0)
      for (const effect of m.effects as Record<string, unknown>[]) {
        expect(typeof effect.type).toBe("string")
      }
    }
  })

  it("toH returns all fields", () => {
    const m = Melhoria.first()!
    const h = m.toH()
    expect(h).toMatchObject({ id: m.id, name: m.name })
    expect(h.effects).toBeDefined()
  })
})
