import { describe, it, expect } from "vitest"
import { Armadura } from "../../../src/ts/models/armadura.js"

describe("Armadura", () => {
  it("has armaduras loaded", () => {
    expect(Armadura.count()).toBeGreaterThan(0)
  })

  it("every armadura has a positive defense_bonus", () => {
    for (const a of Armadura.all()) {
      expect(a.id).toBeTruthy()
      expect(["leve", "pesada"]).toContain(a.category)
      expect(a.defenseBonus).toBeGreaterThan(0)
    }
  })

  describe("scopes", () => {
    it("leves returns only leve armaduras", () => {
      Armadura.leves().all().forEach((a) => expect(a.category).toBe("leve"))
    })

    it("pesadas returns only pesada armaduras", () => {
      Armadura.pesadas().all().forEach((a) => expect(a.category).toBe("pesada"))
    })
  })

  describe("instance methods", () => {
    it("isLeve/isPesada are correct", () => {
      const leve = Armadura.leves().first()!
      expect(leve.isLeve).toBe(true)
      expect(leve.isPesada).toBe(false)
    })

    it("find returns cota_de_malha with +6 bonus", () => {
      const cota = Armadura.find("cota_de_malha")
      expect(cota).not.toBeNull()
      expect(cota!.defenseBonus).toBe(6)
    })
  })
})
