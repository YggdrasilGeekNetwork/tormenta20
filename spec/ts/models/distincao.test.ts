import { describe, it, expect } from "vitest"
import { Distincao } from "../../../src/ts/models/distincao.js"
import { Poder } from "../../../src/ts/models/poder.js"

describe("Distincao", () => {
  it("has distincoes loaded", () => {
    expect(Distincao.count()).toBeGreaterThan(0)
  })

  it("every distincao has id, name, admissao, marca and nivelMinimo 5 (veterano)", () => {
    for (const d of Distincao.all()) {
      expect(d.id).toBeTruthy()
      expect(d.name).toBeTruthy()
      expect(d.admissao).toBeTruthy()
      expect(d.marcaNome).toBeTruthy()
      expect(d.marcaDescricao).toBeTruthy()
      expect(d.nivelMinimo).toBe(5)
    }
  })

  it("finds a known distincao by id", () => {
    const amazona = Distincao.find("amazona")
    expect(amazona).not.toBeNull()
    expect(amazona!.name).toBe("Amazona")
    expect(amazona!.nivelMinimo).toBe(5)
    expect(amazona!.livroId).toBe("herois_de_arton")
  })

  it("every distincao's powers are reachable via Poder.byDistincao", () => {
    for (const d of Distincao.all()) {
      const powers = Poder.byDistincao(d.id).all()
      expect(powers.length, `${d.id}: has no poder_distincao powers`).toBeGreaterThan(0)
      powers.forEach((p) => {
        expect(p.type).toBe("poder_distincao")
        expect(p.distincaoId).toBe(d.id)
      })
    }
  })

  it("toH returns all fields", () => {
    const d = Distincao.first()!
    const h = d.toH()
    expect(h).toMatchObject({ id: d.id, name: d.name })
    expect(h.admissao).toBeDefined()
  })
})
