import { describe, it, expect } from "vitest"
import { Classe } from "../../../src/ts/models/classe.js"

describe("Classe", () => {
  describe("data integrity", () => {
    it("has classes loaded from the database", () => {
      expect(Classe.count()).toBeGreaterThan(0)
    })

    it("every classe has id and name", () => {
      for (const c of Classe.all()) {
        expect(c.id).toBeTruthy()
        expect(c.name).toBeTruthy()
      }
    })
  })

  describe("find", () => {
    it("returns guerreiro with correct stats", () => {
      const g = Classe.find("guerreiro")
      expect(g).not.toBeNull()
      expect(g!.initialHp).toBe(20)
      expect(g!.hpPerLevel).toBe(5)
      expect(g!.mpPerLevel).toBe(3)
    })

    it("returns null for unknown id", () => {
      expect(Classe.find("nonexistent")).toBeNull()
    })
  })

  describe("HP and MP helpers", () => {
    it("guerreiro has correct hp and mp", () => {
      const g = Classe.find("guerreiro")!
      expect(g.initialHp).toBeGreaterThan(0)
      expect(g.hpPerLevel).toBeGreaterThan(0)
    })

    it("every classe has positive hp_per_level", () => {
      for (const c of Classe.all()) {
        expect(c.hpPerLevel).toBeGreaterThan(0)
      }
    })
  })

  describe("proficiencies", () => {
    it("guerreiro has weapon proficiencies", () => {
      const g = Classe.find("guerreiro")!
      expect(g.weaponProficiencies).toContain("marciais")
    })

    it("guerreiro has shield proficiency", () => {
      const g = Classe.find("guerreiro")!
      expect(g.shieldProficiency).toBe(true)
    })
  })

  describe("toH", () => {
    it("returns all keys", () => {
      const c = Classe.first()!
      const h = c.toH()
      expect(h).toMatchObject({ id: c.id, name: c.name })
      expect(h.hit_points).toBeDefined()
      expect(h.mana_points).toBeDefined()
    })
  })
})
