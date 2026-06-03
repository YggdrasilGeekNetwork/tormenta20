import { describe, it, expect } from "vitest"
import { Origem } from "../../../src/ts/models/origem.js"

describe("Origem", () => {
  describe("data integrity", () => {
    it("has origens loaded from the database", () => {
      expect(Origem.count()).toBeGreaterThan(0)
    })

    it("every origem has id and name", () => {
      for (const o of Origem.all()) {
        expect(o.id).toBeTruthy()
        expect(o.name).toBeTruthy()
      }
    })
  })

  describe("find", () => {
    it("returns acolito with correct skills", () => {
      const o = Origem.find("acolito")
      expect(o).not.toBeNull()
      expect(o!.skills().length).toBeGreaterThan(0)
    })
  })

  describe("scopes", () => {
    it("withUniquePower returns only origins with a unique power", () => {
      const result = Origem.withUniquePower().all()
      expect(result.length).toBeGreaterThan(0)
      result.forEach((o) => expect(o.uniquePower).not.toBeNull())
    })
  })

  describe("instance methods", () => {
    it("skills returns an array", () => {
      expect(Array.isArray(Origem.first()!.skills())).toBe(true)
    })

    it("powers returns an array", () => {
      expect(Array.isArray(Origem.first()!.powers())).toBe(true)
    })

    it("toH returns all keys", () => {
      const o = Origem.first()!
      const h = o.toH()
      expect(h).toMatchObject({ id: o.id, name: o.name })
    })
  })
})
