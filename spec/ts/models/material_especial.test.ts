import { describe, it, expect } from "vitest"
import { MaterialEspecial } from "../../../src/ts/models/material_especial.js"

describe("MaterialEspecial", () => {
  it("has materiais loaded", () => {
    expect(MaterialEspecial.count()).toBeGreaterThan(0)
  })

  it("every material has id and name", () => {
    for (const m of MaterialEspecial.all()) {
      expect(m.id).toBeTruthy()
      expect(m.name).toBeTruthy()
    }
  })

  it("priceModifier is an object", () => {
    for (const m of MaterialEspecial.all()) {
      expect(typeof m.priceModifier).toBe("object")
    }
  })

  it("effects is an object keyed by category, each value a non-empty array of typed objects", () => {
    for (const m of MaterialEspecial.all()) {
      expect(typeof m.effects).toBe("object")
      for (const categoryEffects of Object.values(m.effects)) {
        expect(Array.isArray(categoryEffects)).toBe(true)
        expect((categoryEffects as unknown[]).length).toBeGreaterThan(0)
        for (const effect of categoryEffects as Record<string, unknown>[]) {
          expect(typeof effect.type).toBe("string")
        }
      }
    }
  })

  it("toH returns all fields", () => {
    const m = MaterialEspecial.first()!
    const h = m.toH()
    expect(h).toMatchObject({ id: m.id, name: m.name })
    expect(h.price_modifier).toBeDefined()
    expect(h.effects).toBeDefined()
  })
})
