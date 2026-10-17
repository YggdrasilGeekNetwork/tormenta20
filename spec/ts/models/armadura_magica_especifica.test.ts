import { describe, it, expect } from "vitest"
import { ArmaduraMagicaEspecifica } from "../../../src/ts/models/armadura_magica_especifica.js"

describe("ArmaduraMagicaEspecifica", () => {
  it("has armaduras magicas especificas loaded", () => {
    expect(ArmaduraMagicaEspecifica.count()).toBeGreaterThan(0)
  })

  it("every armadura has id, name and valid subtipo", () => {
    for (const a of ArmaduraMagicaEspecifica.all()) {
      expect(a.id).toBeTruthy()
      expect(a.name).toBeTruthy()
      expect(["armadura", "escudo"]).toContain(a.subtipo)
    }
  })

  it("every armadura has a non-empty effects array of typed objects", () => {
    for (const a of ArmaduraMagicaEspecifica.all()) {
      expect(Array.isArray(a.effects)).toBe(true)
      expect(a.effects.length).toBeGreaterThan(0)
      for (const effect of a.effects as Record<string, unknown>[]) {
        expect(typeof effect.type).toBe("string")
      }
    }
  })

  describe("scopes", () => {
    it("armaduras returns only subtipo armadura", () => {
      ArmaduraMagicaEspecifica.armaduras().all().forEach((a) => expect(a.subtipo).toBe("armadura"))
    })

    it("escudos returns only subtipo escudo", () => {
      ArmaduraMagicaEspecifica.escudos().all().forEach((a) => expect(a.subtipo).toBe("escudo"))
    })
  })

  it("toH returns all fields", () => {
    const a = ArmaduraMagicaEspecifica.first()!
    const h = a.toH()
    expect(h).toMatchObject({ id: a.id, name: a.name, subtipo: a.subtipo })
    expect(h.effects).toBeDefined()
  })
})
