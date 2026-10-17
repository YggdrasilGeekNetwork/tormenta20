import { describe, it, expect } from "vitest"
import { Mobilia } from "../../../src/ts/models/mobilia.js"

describe("Mobilia", () => {
  it("has the 25 mobílias loaded", () => {
    expect(Mobilia.count()).toBe(25)
  })

  it("every mobília has id, name, description and non-empty effects", () => {
    for (const m of Mobilia.all()) {
      expect(m.id).toBeTruthy()
      expect(m.name).toBeTruthy()
      expect(m.description).toBeTruthy()
      expect(Array.isArray(m.effects)).toBe(true)
      expect(m.effects.length).toBeGreaterThan(0)
    }
  })

  const bar = new Mobilia({
    id: "bar",
    name: "Bar",
    description: "Um balcão com bancos altos. Fornece +1 PM para os residentes.",
    effects: JSON.stringify([{ type: "bonus_pm", value: 1 }]),
    preco: 1000,
    comodo_alvo: null,
  })

  it("exposes preco and effects", () => {
    expect(bar.preco).toBe(1000)
    expect(bar.effects).toEqual([{ type: "bonus_pm", value: 1 }])
  })

  it("toH returns a plain object", () => {
    const h = bar.toH()
    expect(h.id).toBe("bar")
    expect(h.preco).toBe(1000)
  })

  it("supports a comodo_alvo restriction", () => {
    const banheira = new Mobilia({ id: "banheira", name: "Banheira", preco: 300, comodo_alvo: "suite" })
    expect(banheira.comodoAlvo).toBe("suite")
  })
})
