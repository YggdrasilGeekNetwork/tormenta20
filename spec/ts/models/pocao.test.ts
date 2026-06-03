import { describe, it, expect } from "vitest"
import { Pocao } from "../../../src/ts/models/pocao.js"

describe("Pocao", () => {
  it("has pocoes loaded", () => {
    expect(Pocao.count()).toBeGreaterThan(0)
  })

  it("every pocao has id, name, and subtipo", () => {
    for (const p of Pocao.all()) {
      expect(p.id).toBeTruthy()
      expect(p.name).toBeTruthy()
      expect(p.subtipo).toBeTruthy()
      expect(p.pmCost).toBeGreaterThan(0)
    }
  })

  describe("scopes", () => {
    it("menores returns only menor categoria", () => {
      Pocao.menores().all().forEach((p) => expect(p.categoria).toBe("menor"))
    })

    it("pocoes returns only pocao subtipo", () => {
      Pocao.pocoes().all().forEach((p) => expect(p.subtipo).toBe("pocao"))
    })

    it("oleos returns only oleo subtipo", () => {
      Pocao.oleos().all().forEach((p) => expect(p.subtipo).toBe("oleo"))
    })
  })

  it("toH returns all fields", () => {
    const p = Pocao.first()!
    const h = p.toH()
    expect(h).toMatchObject({ id: p.id, subtipo: p.subtipo, pm_cost: p.pmCost })
  })
})
