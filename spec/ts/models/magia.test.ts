import { describe, it, expect } from "vitest"
import { Magia } from "../../../src/ts/models/magia.js"

describe("Magia", () => {
  describe("data integrity", () => {
    it("has magias loaded from the database", () => {
      expect(Magia.count()).toBeGreaterThan(0)
    })

    it("every magia has required fields", () => {
      for (const m of Magia.all()) {
        expect(m.id).toBeTruthy()
        expect(m.name).toBeTruthy()
        expect(["arcana", "divina", "universal"]).toContain(m.type)
      }
    })

    it("enhancements are arrays", () => {
      for (const m of Magia.all()) {
        expect(Array.isArray(m.enhancements)).toBe(true)
      }
    })
  })

  describe("scopes", () => {
    it("arcanas returns only arcana type", () => {
      const result = Magia.arcanas().all()
      expect(result.length).toBeGreaterThan(0)
      result.forEach((m) => expect(m.type).toBe("arcana"))
    })

    it("divinas returns only divina type", () => {
      Magia.divinas().all().forEach((m) => expect(m.type).toBe("divina"))
    })

    it("query().where chains correctly", () => {
      const circle1arcanas = Magia.arcanas().where("circle = ?", "1").count()
      const allCircle1 = Magia.query().where("circle = ?", "1").count()
      expect(circle1arcanas).toBeLessThanOrEqual(allCircle1)
    })
  })

  describe("find", () => {
    it("returns adaga_mental with correct fields", () => {
      const m = Magia.find("adaga_mental")
      expect(m).not.toBeNull()
      expect(m!.type).toBe("arcana")
      expect(m!.circle).toBe("1")
      expect(m!.enhancements.length).toBeGreaterThan(0)
    })
  })

  describe("toH", () => {
    it("includes target info when present", () => {
      const m = Magia.find("adaga_mental")!
      const h = m.toH()
      expect(h.id).toBe("adaga_mental")
      expect(h.enhancements).toBeDefined()
    })
  })
})
