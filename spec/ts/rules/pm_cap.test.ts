import { describe, it, expect } from "vitest"
import { PmCap } from "../../../src/ts/rules/pm_cap.js"

describe("PmCap", () => {
  describe("forAbility", () => {
    it("returns character level when no source class is given", () => {
      expect(PmCap.forAbility({ characterLevel: 5 })).toBe(5)
    })

    it("returns character level when sourceClass is null", () => {
      expect(PmCap.forAbility({ characterLevel: 7, sourceClass: null })).toBe(7)
    })

    it("returns character level when classLevel is null", () => {
      expect(PmCap.forAbility({ characterLevel: 7, sourceClass: "guerreiro", classLevel: null })).toBe(7)
    })

    it("returns class level when sourceClass and classLevel are provided", () => {
      expect(PmCap.forAbility({ characterLevel: 10, classLevel: 6, sourceClass: "arcanista" })).toBe(6)
    })

    it("class level is lower bound when class level < character level", () => {
      const cap = PmCap.forAbility({ characterLevel: 10, classLevel: 3, sourceClass: "clerigo" })
      expect(cap).toBe(3)
    })

    it("class level equal to character level (single-class character)", () => {
      const cap = PmCap.forAbility({ characterLevel: 5, classLevel: 5, sourceClass: "guerreiro" })
      expect(cap).toBe(5)
    })
  })
})
