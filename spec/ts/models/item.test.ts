import { describe, it, expect } from "vitest"
import { Item } from "../../../src/ts/models/item.js"

describe("Item", () => {
  it("has itens loaded", () => {
    expect(Item.count()).toBeGreaterThan(0)
  })

  it("every item has id and name", () => {
    for (const i of Item.all()) {
      expect(i.id).toBeTruthy()
      expect(i.name).toBeTruthy()
    }
  })

  it("effects is always an object", () => {
    for (const i of Item.all()) {
      expect(typeof i.effects).toBe("object")
    }
  })

  describe("byCategory", () => {
    it("filters by category", () => {
      const first = Item.query().where("category IS NOT NULL").first()
      if (!first?.category) return
      Item.byCategory(first.category).all().forEach((i) => {
        expect(i.category).toBe(first.category)
      })
    })
  })

  it("toH returns all fields", () => {
    const i = Item.first()!
    const h = i.toH()
    expect(h).toMatchObject({ id: i.id, name: i.name })
    expect(h.effects).toBeDefined()
  })
})
