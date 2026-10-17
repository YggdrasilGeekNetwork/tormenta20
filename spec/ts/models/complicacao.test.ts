import { describe, it, expect } from "vitest"
import { Complicacao } from "../../../src/ts/models/complicacao.js"

describe("Complicacao", () => {
  it("has complicações loaded", () => {
    expect(Complicacao.count()).toBeGreaterThan(0)
  })

  it("every complicação has id, name, categoria and non-empty effects", () => {
    for (const c of Complicacao.all()) {
      expect(c.id).toBeTruthy()
      expect(c.name).toBeTruthy()
      expect(c.categoria).toBeTruthy()
      expect(Array.isArray(c.effects)).toBe(true)
      expect(c.effects.length).toBeGreaterThan(0)
    }
  })

  it("has 32 gerais", () => {
    expect(Complicacao.gerais().count()).toBe(32)
  })

  describe("scopes", () => {
    it("gerais returns only categoria geral", () => {
      Complicacao.gerais().all().forEach((c) => expect(c.categoria).toBe("geral"))
    })

    it("byCategoria filters by the given categoria", () => {
      Complicacao.byCategoria("guerreiro").all().forEach((c) => expect(c.categoria).toBe("guerreiro"))
    })
  })

  it("toH returns a plain object with all expected keys", () => {
    const c = Complicacao.first()!
    const h = c.toH()
    expect(h).toMatchObject({ id: c.id, name: c.name, categoria: c.categoria })
    expect(Array.isArray(h.effects)).toBe(true)
  })
})
