import { describe, it, expect } from "vitest"
import { Condicao } from "../../../src/ts/models/condicao.js"

describe("Condicao", () => {
  it("has condicoes loaded", () => {
    expect(Condicao.count()).toBeGreaterThan(0)
  })

  it("every condicao has id and name", () => {
    for (const c of Condicao.all()) {
      expect(c.id).toBeTruthy()
      expect(c.name).toBeTruthy()
      expect(Array.isArray(c.effects)).toBe(true)
    }
  })

  describe("scopes", () => {
    it("medo returns only medo type", () => {
      const result = Condicao.medo().all()
      expect(result.length).toBeGreaterThan(0)
      result.forEach((c) => expect(c.conditionType).toBe("medo"))
    })

    it("mental returns only mental type", () => {
      Condicao.mental().all().forEach((c) => expect(c.conditionType).toBe("mental"))
    })
  })

  it("escalates_to can be null or a string", () => {
    for (const c of Condicao.all()) {
      expect(c.escalatesTo === null || typeof c.escalatesTo === "string").toBe(true)
    }
  })
})
