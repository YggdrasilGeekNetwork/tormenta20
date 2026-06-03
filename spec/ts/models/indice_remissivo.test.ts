import { describe, it, expect } from "vitest"
import { IndiceRemissivo } from "../../../src/ts/models/indice_remissivo.js"

describe("IndiceRemissivo", () => {
  it("has entries loaded", () => {
    expect(IndiceRemissivo.count()).toBeGreaterThan(0)
  })

  it("every entry has termo and pagina > 0", () => {
    for (const i of IndiceRemissivo.all()) {
      expect(i.termo).toBeTruthy()
      expect(i.pagina).toBeGreaterThan(0)
    }
  })

  describe("scopes", () => {
    it("associados returns entries with registroId", () => {
      IndiceRemissivo.associados().all().forEach((i) => expect(i.registroId).not.toBeNull())
    })

    it("naoAssociados returns entries without registroId", () => {
      IndiceRemissivo.naoAssociados().all().forEach((i) => expect(i.registroId).toBeNull())
    })

    it("buscarTermo filters by substring", () => {
      const results = IndiceRemissivo.buscarTermo("espada").all()
      results.forEach((i) => expect(i.termo.toLowerCase()).toContain("espada"))
    })
  })

  it("associado reflects registroId presence", () => {
    for (const i of IndiceRemissivo.all()) {
      expect(i.associado).toBe(i.registroId !== null)
    }
  })

  it("toH returns termo and pagina", () => {
    const i = IndiceRemissivo.first()!
    const h = i.toH()
    expect(h.termo).toBe(i.termo)
    expect(h.pagina).toBe(i.pagina)
  })
})
