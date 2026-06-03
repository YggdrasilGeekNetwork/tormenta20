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

  it("effects is always an object", () => {
    for (const m of Melhoria.all()) {
      expect(typeof m.effects).toBe("object")
    }
  })

  it("toH returns all fields", () => {
    const m = Melhoria.first()!
    const h = m.toH()
    expect(h).toMatchObject({ id: m.id, name: m.name })
    expect(h.effects).toBeDefined()
  })
})
