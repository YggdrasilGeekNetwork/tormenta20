import { describe, it, expect } from "vitest"
import { ItemLiturgico } from "../../../src/ts/models/item_liturgico.js"

describe("ItemLiturgico", () => {
  it("has itens liturgicos loaded", () => {
    expect(ItemLiturgico.count()).toBeGreaterThan(0)
  })

  it("every item has id, name and at least one deity", () => {
    for (const i of ItemLiturgico.all()) {
      expect(i.id).toBeTruthy()
      expect(i.name).toBeTruthy()
      expect(Array.isArray(i.deities)).toBe(true)
      expect(i.deities.length).toBeGreaterThan(0)
    }
  })

  it("every item has a non-empty effects array of typed objects", () => {
    for (const i of ItemLiturgico.all()) {
      expect(Array.isArray(i.effects)).toBe(true)
      expect(i.effects.length).toBeGreaterThan(0)
      for (const effect of i.effects as Record<string, unknown>[]) {
        expect(typeof effect.type).toBe("string")
      }
    }
  })

  describe("byDeity", () => {
    it("returns only items associated with the given deity", () => {
      const i = ItemLiturgico.first()!
      const deity = i.deities[0]
      ItemLiturgico.byDeity(deity).all().forEach((x) => expect(x.deities).toContain(deity))
    })
  })

  describe("bySubtipo", () => {
    it("returns only items of the given subtipo", () => {
      const i = ItemLiturgico.all().find((x) => x.subtipo !== null)!
      ItemLiturgico.bySubtipo(i.subtipo!).all().forEach((x) => expect(x.subtipo).toBe(i.subtipo))
    })
  })

  it("toH returns all fields", () => {
    const i = ItemLiturgico.first()!
    const h = i.toH()
    expect(h).toMatchObject({ id: i.id, name: i.name })
    expect(h.deities).toBeDefined()
    expect(h.effects).toBeDefined()
  })
})
