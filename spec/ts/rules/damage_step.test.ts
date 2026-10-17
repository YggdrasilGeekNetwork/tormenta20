import { describe, it, expect } from "vitest"
import { DamageStep } from "../../../src/ts/rules/damage_step.js"

describe("DamageStep", () => {
  describe("adjust", () => {
    it("steps up by 1", () => {
      expect(DamageStep.adjust("1d8", 1)).toBe("1d10")
    })

    it("steps up by 2", () => {
      expect(DamageStep.adjust("1d8", 2)).toBe("1d12")
    })

    it("steps up by the maximum, 3", () => {
      expect(DamageStep.adjust("1d8", 3)).toBe("3d6")
    })

    it("steps down by 1", () => {
      expect(DamageStep.adjust("1d8", -1)).toBe("1d6")
    })

    it("steps down by the minimum, -2", () => {
      expect(DamageStep.adjust("1d8", -2)).toBe("1d4")
    })

    it("returns the same die when steps is 0", () => {
      expect(DamageStep.adjust("1d10", 0)).toBe("1d10")
    })

    it("clamps steps beyond +3 to the top of the table", () => {
      expect(DamageStep.adjust("1d8", 10)).toBe(DamageStep.adjust("1d8", 3))
    })

    it("clamps steps below -2 to the bottom of the table", () => {
      expect(DamageStep.adjust("1d8", -10)).toBe(DamageStep.adjust("1d8", -2))
    })

    it("returns undefined for a die that isn't a normal-column entry", () => {
      expect(DamageStep.adjust("1d20", 1)).toBeUndefined()
    })

    it("works at the top row of the table", () => {
      expect(DamageStep.adjust("2d10", 1)).toBe("3d10")
    })

    it("works at the bottom row of the table", () => {
      expect(DamageStep.adjust("1d3", -1)).toBe("1d2")
    })
  })
})
