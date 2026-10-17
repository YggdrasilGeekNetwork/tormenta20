import { describe, it, expect } from "vitest"
import { Comodo } from "../../../src/ts/models/comodo.js"

describe("Comodo", () => {
  it("has the 41 cômodos loaded", () => {
    expect(Comodo.count()).toBe(41)
  })

  it("every cômodo has id, name, description and non-empty effects", () => {
    for (const c of Comodo.all()) {
      expect(c.id).toBeTruthy()
      expect(c.name).toBeTruthy()
      expect(c.description).toBeTruthy()
      expect(Array.isArray(c.effects)).toBe(true)
      expect(c.effects.length).toBeGreaterThan(0)
    }
  })

  const biblioteca = new Comodo({
    id: "biblioteca",
    name: "Biblioteca",
    description: "Estantes recheadas de livros e pergaminhos. Os residentes recebem +1 em Conhecimento.",
    effects: JSON.stringify([{ type: "bonus_pericia", pericia: "conhecimento", value: 1 }]),
    prerequisito: null,
  })

  it("parses effects from JSON", () => {
    expect(biblioteca.effects).toEqual([{ type: "bonus_pericia", pericia: "conhecimento", value: 1 }])
  })

  it("toH returns a plain object", () => {
    const h = biblioteca.toH()
    expect(h.id).toBe("biblioteca")
    expect(Array.isArray(h.effects)).toBe(true)
  })

  it("supports a prerequisito", () => {
    const sauna = new Comodo({ id: "sauna", name: "Sauna", prerequisito: "base formidável ou melhor" })
    expect(sauna.prerequisito).toBe("base formidável ou melhor")
  })
})
