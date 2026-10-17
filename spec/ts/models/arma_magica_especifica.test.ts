import { describe, it, expect } from "vitest"
import { ArmaMagicaEspecifica } from "../../../src/ts/models/arma_magica_especifica.js"

describe("ArmaMagicaEspecifica", () => {
  it("has armas magicas especificas loaded", () => {
    expect(ArmaMagicaEspecifica.count()).toBeGreaterThan(0)
  })

  it("every arma has id, name and base_weapon", () => {
    for (const a of ArmaMagicaEspecifica.all()) {
      expect(a.id).toBeTruthy()
      expect(a.name).toBeTruthy()
      expect(a.baseWeapon).toBeTruthy()
    }
  })

  it("every arma has a non-empty effects array of typed objects", () => {
    for (const a of ArmaMagicaEspecifica.all()) {
      expect(Array.isArray(a.effects)).toBe(true)
      expect(a.effects.length).toBeGreaterThan(0)
      for (const effect of a.effects as Record<string, unknown>[]) {
        expect(typeof effect.type).toBe("string")
      }
    }
  })

  describe("byBase", () => {
    it("returns only armas built on the given base weapon", () => {
      const a = ArmaMagicaEspecifica.first()!
      ArmaMagicaEspecifica.byBase(a.baseWeapon!).all().forEach((x) => expect(x.baseWeapon).toBe(a.baseWeapon))
    })
  })

  it("toH returns all fields", () => {
    const a = ArmaMagicaEspecifica.first()!
    const h = a.toH()
    expect(h).toMatchObject({ id: a.id, name: a.name, base_weapon: a.baseWeapon })
    expect(h.effects).toBeDefined()
  })
})
