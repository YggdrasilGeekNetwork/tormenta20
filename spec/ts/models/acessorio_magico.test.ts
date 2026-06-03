import { describe, it, expect } from "vitest"
import { AcessorioMagico } from "../../../src/ts/models/acessorio_magico.js"

describe("AcessorioMagico", () => {
  it("has acessorios loaded", () => {
    expect(AcessorioMagico.count()).toBeGreaterThan(0)
  })

  it("every acessorio has id, name, and categoria", () => {
    for (const a of AcessorioMagico.all()) {
      expect(a.id).toBeTruthy()
      expect(a.name).toBeTruthy()
      expect(a.categoria).toBeTruthy()
    }
  })

  it("efeito is always an object", () => {
    for (const a of AcessorioMagico.all()) {
      expect(typeof a.efeito).toBe("object")
    }
  })

  describe("scopes", () => {
    it("menores returns only menor categoria", () => {
      AcessorioMagico.menores().all().forEach((a) => expect(a.categoria).toBe("menor"))
    })

    it("maiores returns only maior categoria", () => {
      AcessorioMagico.maiores().all().forEach((a) => expect(a.categoria).toBe("maior"))
    })
  })

  it("toH returns all fields", () => {
    const a = AcessorioMagico.first()!
    const h = a.toH()
    expect(h).toMatchObject({ id: a.id, name: a.name, categoria: a.categoria })
    expect(h.efeito).toBeDefined()
  })
})
