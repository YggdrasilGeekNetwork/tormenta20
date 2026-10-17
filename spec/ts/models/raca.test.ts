import { describe, it, expect } from "vitest"
import { Raca } from "../../../src/ts/models/raca.js"
import { Poder } from "../../../src/ts/models/poder.js"

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

  describe("Heróis de Arton fields", () => {
    it("galokk and meio_elfo use chosenAttributeBonus instead of a fixed value for their extra bonus", () => {
      const galokk = Raca.find("galokk")!
      expect(galokk.chosenAttributeBonus).toEqual({ count: 1, value: 1, exclude: [] })

      const meioElfo = Raca.find("meio_elfo")!
      expect(meioElfo.chosenAttributeBonus).toEqual({ count: 2, value: 1, exclude: ["constituicao"] })
    })

    it("humano (EJA) has no chosenAttributeBonus, longevidade or devocao", () => {
      const humano = Raca.find("humano")!
      expect(humano.chosenAttributeBonus).toBeNull()
      expect(humano.longevidade).toBeNull()
      expect(humano.devocao).toBeNull()
    })

    it("eiradaan has longevidade and devocao populated", () => {
      const eiradaan = Raca.find("eiradaan")!
      expect(eiradaan.longevidade).toBe("x5")
      expect(eiradaan.devocao).toEqual(["allihanna", "lena", "thyatis", "wynna"])
    })

    it("every racialAbilities and availableChosenAbilities id resolves to a real habilidade_de_raca poder", () => {
      for (const r of Raca.all()) {
        const ids = [...r.racialAbilities, ...(r.availableChosenAbilities as string[])]
        for (const abilityId of ids) {
          const poder = Poder.find(abilityId)
          expect(poder, `${r.id}: racial ability ${abilityId} not found in poderes`).not.toBeNull()
          expect(poder!.type).toBe("habilidade_de_raca")
        }
      }
    })

    it("duende uses chosenAbilitiesAmount for its 3 presentes, chosen from 12 options", () => {
      const duende = Raca.find("duende")!
      expect(duende.chosenAbilitiesAmount).toBe(3)
      expect(duende.availableChosenAbilities.length).toBe(12)
    })
  })

  describe("Deuses de Arton fields", () => {
    it("aggelus and sulfure share the same 22-option abilitySwap pool, replacing their own fixed ability", () => {
      const aggelus = Raca.find("aggelus")!
      expect(aggelus.abilitySwap?.replaces).toBe("luz_sagrada")
      expect(aggelus.abilitySwap?.options.length).toBe(22)

      const sulfure = Raca.find("sulfure")!
      expect(sulfure.abilitySwap?.replaces).toBe("sombras_profanas")
      expect(sulfure.abilitySwap?.options).toEqual(aggelus.abilitySwap?.options)
    })

    it("every abilitySwap option resolves to a real habilidade_de_raca poder from Deuses de Arton", () => {
      for (const r of Raca.all()) {
        if (!r.abilitySwap) continue

        for (const abilityId of r.abilitySwap.options) {
          const poder = Poder.find(abilityId)
          expect(poder, `${r.id}: abilitySwap option ${abilityId} not found in poderes`).not.toBeNull()
          expect(poder!.type).toBe("habilidade_de_raca")
        }
      }
    })

    it("races without variants have no abilitySwap", () => {
      expect(Raca.find("humano")!.abilitySwap).toBeNull()
    })
  })
})
