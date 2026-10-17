import { describe, it, expect } from "vitest"
import { Tabela } from "../../../src/ts/models/tabela.js"

describe("Tabela", () => {
  it("has tabelas loaded", () => {
    expect(Tabela.count()).toBeGreaterThan(0)
  })

  it("headers and rows are non-empty arrays", () => {
    for (const t of Tabela.all()) {
      expect(Array.isArray(t.headers)).toBe(true)
      expect(t.headers.length).toBeGreaterThan(0)
      expect(Array.isArray(t.rows)).toBe(true)
      expect(t.rows.length).toBeGreaterThan(0)
    }
  })

  it("toH returns headers and rows", () => {
    const t = Tabela.first()!
    const h = t.toH()
    expect(h).toMatchObject({ id: t.id, name: t.name })
    expect(Array.isArray(h.headers)).toBe(true)
    expect(Array.isArray(h.rows)).toBe(true)
  })

  describe("sorteio (roll)", () => {
    const rollable = new Tabela({
      id: "teste_sorteio",
      name: "Teste de Sorteio",
      headers: JSON.stringify(["Faixa", "Resultado"]),
      rows: JSON.stringify([
        { Faixa: "01-50", Resultado: "A" },
        { Faixa: "51-100", Resultado: "B" },
      ]),
      dice: "1d100",
    })

    const nonRollable = new Tabela({
      id: "sem_dado",
      name: "Sem Dado",
      headers: JSON.stringify(["X"]),
      rows: JSON.stringify([{ X: "1" }]),
      dice: null,
    })

    it("sorteavel is true only when dice is set", () => {
      expect(rollable.sorteavel).toBe(true)
      expect(nonRollable.sorteavel).toBe(false)
    })

    it("roll throws when the table has no dice column", () => {
      expect(() => nonRollable.roll()).toThrow(/não é sorteável/)
    })

    it("roll always returns a row matching a valid dice range", () => {
      for (let i = 0; i < 100; i++) {
        expect(rollable.roll()).not.toBeNull()
      }
    })

    it("roll returns a row whose range contains the result", () => {
      const original = Math.random
      try {
        Math.random = () => 0.1 // -> result 11, falls in "01-50"
        expect(rollable.roll()).toEqual({ Faixa: "01-50", Resultado: "A" })

        Math.random = () => 0.9 // -> result 91, falls in "51-100"
        expect(rollable.roll()).toEqual({ Faixa: "51-100", Resultado: "B" })
      } finally {
        Math.random = original
      }
    })
  })
})
