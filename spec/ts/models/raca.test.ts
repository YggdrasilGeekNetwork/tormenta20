import { describe, it, expect } from "vitest"
import { Raca } from "../../../src/ts/models/raca.js"

describe("Raca", () => {
  it("has racas loaded", () => {
    expect(Raca.count()).toBeGreaterThan(0)
  })

  it("every raca has size and movement", () => {
    for (const r of Raca.all()) {
      expect(r.id).toBeTruthy()
      expect(r.name).toBeTruthy()
      expect(r.movement).toBeGreaterThan(0)
    }
  })

  describe("find", () => {
    it("returns humano with médio size", () => {
      const r = Raca.find("humano")
      expect(r).not.toBeNull()
      expect(r!.size).toBe("médio")
    })

    it("returns null for unknown id", () => {
      expect(Raca.find("nonexistent")).toBeNull()
    })
  })

  describe("instance methods", () => {
    it("attributeBonusFor returns 0 when no bonus", () => {
      const h = Raca.find("humano")!
      expect(h.attributeBonusFor("FOR")).toBe(0)
    })

    it("racial_abilities is an array", () => {
      for (const r of Raca.all()) {
        expect(Array.isArray(r.racialAbilities)).toBe(true)
      }
    })
  })
})
