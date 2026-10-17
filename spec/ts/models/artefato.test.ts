import { describe, it, expect } from "vitest"
import { Artefato } from "../../../src/ts/models/artefato.js"

describe("Artefato", () => {
  it("has artefatos loaded", () => {
    expect(Artefato.count()).toBeGreaterThan(0)
  })

  it("every artefato has id, name and description", () => {
    for (const a of Artefato.all()) {
      expect(a.id).toBeTruthy()
      expect(a.name).toBeTruthy()
      expect(a.description).toBeTruthy()
    }
  })

  it("every artefato has a non-empty effects array of typed objects", () => {
    for (const a of Artefato.all()) {
      expect(Array.isArray(a.effects)).toBe(true)
      expect(a.effects.length).toBeGreaterThan(0)
      for (const effect of a.effects as Record<string, unknown>[]) {
        expect(typeof effect.type).toBe("string")
      }
    }
  })

  it("finds a known artefato by id", () => {
    const espadaDeus = Artefato.find("espada_deus")
    expect(espadaDeus).not.toBeNull()
    expect(espadaDeus!.name).toBe("A Espada-Deus")
  })

  it("toH returns all fields", () => {
    const a = Artefato.first()!
    const h = a.toH()
    expect(h).toMatchObject({ id: a.id, name: a.name })
    expect(h.effects).toBeDefined()
  })
})
