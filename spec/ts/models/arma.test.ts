import { describe, it, expect } from "vitest"
import { Arma } from "../../../src/ts/models/arma.js"

describe("Arma", () => {
  describe("data integrity", () => {
    it("has armas loaded from the database", () => {
      expect(Arma.count()).toBeGreaterThan(0)
    })

    it("every arma has required fields", () => {
      for (const a of Arma.all()) {
        expect(a.id).toBeTruthy()
        expect(a.name).toBeTruthy()
        expect(["simples", "marciais", "exoticas", "fogo"]).toContain(a.category)
      }
    })
  })

  describe("find", () => {
    it("returns the correct arma by id", () => {
      const adaga = Arma.find("adaga")
      expect(adaga).not.toBeNull()
      expect(adaga!.name).toBe("Adaga")
      expect(adaga!.category).toBe("simples")
      expect(adaga!.damage).toBe("1d4")
    })

    it("returns null for unknown id", () => {
      expect(Arma.find("nonexistent")).toBeNull()
    })
  })

  describe("scopes", () => {
    it("simples returns only simples weapons", () => {
      const result = Arma.simples().all()
      expect(result.length).toBeGreaterThan(0)
      result.forEach((a) => expect(a.category).toBe("simples"))
    })

    it("marciais returns only marciais weapons", () => {
      Arma.marciais().all().forEach((a) => expect(a.category).toBe("marciais"))
    })

    it("melee returns weapons with no range", () => {
      const result = Arma.melee().all()
      result.forEach((a) => expect(a.range).toBeNull())
    })

    it("ranged returns weapons with a range", () => {
      const result = Arma.ranged().all()
      expect(result.length).toBeGreaterThan(0)
      result.forEach((a) => expect(a.range).not.toBeNull())
    })
  })

  describe("instance methods", () => {
    it("isMelee is true for melee-only weapons", () => {
      const espada = Arma.find("espada_longa")
      expect(espada?.isMelee).toBe(true)
      expect(espada?.isRanged).toBe(false)
    })

    it("toH returns a plain object with all fields", () => {
      const a = Arma.first()!
      const h = a.toH()
      expect(h).toMatchObject({ id: a.id, name: a.name, category: a.category, damage: a.damage })
    })
  })
})
