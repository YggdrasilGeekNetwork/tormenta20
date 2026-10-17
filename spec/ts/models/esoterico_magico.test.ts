import { describe, it, expect } from "vitest"
import { EsotericoMagico } from "../../../src/ts/models/esoterico_magico.js"

describe("EsotericoMagico", () => {
  it("has esotéricos específicos loaded", () => {
    expect(EsotericoMagico.count()).toBeGreaterThan(0)
  })

  it("every esoterico has id, name, categoria and non-empty effects", () => {
    for (const e of EsotericoMagico.all()) {
      expect(e.id).toBeTruthy()
      expect(e.name).toBeTruthy()
      expect(e.categoria).toBeTruthy()
      expect(Array.isArray(e.effects)).toBe(true)
      expect(e.effects.length).toBeGreaterThan(0)
    }
  })

  const esoterico = new EsotericoMagico({
    id: "teste_esoterico",
    name: "Cajado de Teste",
    categoria: "maior",
    preco: 50000,
    roll_min: 1,
    roll_max: 5,
    description: "Um cajado de teste.",
    effects: JSON.stringify([{ type: "bonus_pm", value: 5 }]),
  })

  it("exposes categoria, preco and roll range", () => {
    expect(esoterico.categoria).toBe("maior")
    expect(esoterico.preco).toBe(50000)
    expect(esoterico.rollMin).toBe(1)
    expect(esoterico.rollMax).toBe(5)
  })

  it("parses effects from JSON", () => {
    expect(esoterico.effects).toEqual([{ type: "bonus_pm", value: 5 }])
  })

  it("toH returns a plain object with all expected keys", () => {
    const h = esoterico.toH()
    expect(h).toMatchObject({
      id: "teste_esoterico",
      name: "Cajado de Teste",
      categoria: "maior",
      preco: 50000,
    })
  })
})
