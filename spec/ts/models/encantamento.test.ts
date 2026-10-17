import { describe, it, expect } from "vitest"
import { Encantamento } from "../../../src/ts/models/encantamento.js"

describe("Encantamento", () => {
  it("has encantamentos loaded", () => {
    expect(Encantamento.count()).toBeGreaterThan(0)
  })

  it("every encantamento has valid categoria", () => {
    for (const e of Encantamento.all()) {
      expect(e.id).toBeTruthy()
      expect(e.name).toBeTruthy()
      expect(["arma", "armadura", "esoterico", "acessorio"]).toContain(e.categoria)
    }
  })

  it("boolean fields are properly coerced", () => {
    for (const e of Encantamento.all()) {
      expect(typeof e.escudoOnly).toBe("boolean")
      expect(typeof e.contaComoDois).toBe("boolean")
    }
  })

  describe("scopes", () => {
    it("armas returns only arma categoria", () => {
      Encantamento.armas().all().forEach((e) => expect(e.categoria).toBe("arma"))
    })

    it("armadurasEscudos returns only armadura", () => {
      Encantamento.armadurasEscudos().all().forEach((e) => expect(e.categoria).toBe("armadura"))
    })

    it("escudoOnly returns only shield-exclusive enchantments", () => {
      Encantamento.escudoOnly().all().forEach((e) => expect(e.escudoOnly).toBe(true))
    })

    it("maldicoes returns only cursed enchantments", () => {
      Encantamento.maldicoes().all().forEach((e) => expect(e.maldicao).toBe(true))
    })

    it("naoMaldicoes excludes cursed enchantments", () => {
      Encantamento.naoMaldicoes().all().forEach((e) => expect(e.maldicao).toBe(false))
    })
  })

  it("toH coerces boolean fields", () => {
    const e = Encantamento.first()!
    const h = e.toH()
    expect(typeof h.escudo_only).toBe("boolean")
    expect(typeof h.conta_como_dois).toBe("boolean")
    expect(typeof h.maldicao).toBe("boolean")
  })

  it("every encantamento has a non-empty effects array of typed objects", () => {
    for (const e of Encantamento.all()) {
      expect(Array.isArray(e.effects)).toBe(true)
      expect(e.effects.length).toBeGreaterThan(0)
      for (const effect of e.effects as Record<string, unknown>[]) {
        expect(typeof effect.type).toBe("string")
      }
    }
  })
})
