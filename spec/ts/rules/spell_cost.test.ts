import { describe, it, expect } from "vitest"
import { SpellCost } from "../../../src/ts/rules/spell_cost.js"

describe("SpellCost", () => {
  describe("forCircle", () => {
    it("returns 1 PM for circle 1", () => {
      expect(SpellCost.forCircle(1)).toBe(1)
    })

    it("returns 3 PM for circle 2", () => {
      expect(SpellCost.forCircle(2)).toBe(3)
    })

    it("returns 6 PM for circle 3", () => {
      expect(SpellCost.forCircle(3)).toBe(6)
    })

    it("returns 10 PM for circle 4", () => {
      expect(SpellCost.forCircle(4)).toBe(10)
    })

    it("returns 15 PM for circle 5", () => {
      expect(SpellCost.forCircle(5)).toBe(15)
    })

    it("accepts a string circle, matching how Magia#circle is stored", () => {
      expect(SpellCost.forCircle("3")).toBe(6)
    })

    it("returns undefined for an unknown circle", () => {
      expect(SpellCost.forCircle(6)).toBeUndefined()
    })
  })
})
