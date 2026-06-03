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

  it("toH returns all fields", () => {
    const m = MaterialEspecial.first()!
    const h = m.toH()
    expect(h).toMatchObject({ id: m.id, name: m.name })
    expect(h.price_modifier).toBeDefined()
    expect(h.effects).toBeDefined()
  })
})
