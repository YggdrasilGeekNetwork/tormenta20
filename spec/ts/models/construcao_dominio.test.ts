import { describe, it, expect } from "vitest"
import { ConstrucaoDominio } from "../../../src/ts/models/construcao_dominio.js"

describe("ConstrucaoDominio", () => {
  const biblioteca = new ConstrucaoDominio({
    id: "biblioteca_dominio",
    name: "Biblioteca",
    categoria: "nobreza",
    description: "Com uma coleção de pergaminhos, livros e tomos variados, este lugar tem muito a ensinar. Você se torna treinado em uma perícia.",
    custo: 10,
    effects: JSON.stringify([{ type: "pericia_treinada", value: 1 }]),
    prerequisito: null,
  })

  it("exposes categoria and custo", () => {
    expect(biblioteca.categoria).toBe("nobreza")
    expect(biblioteca.custo).toBe(10)
  })

  it("parses effects from JSON", () => {
    expect(biblioteca.effects).toEqual([{ type: "pericia_treinada", value: 1 }])
  })

  it("toH returns a plain object", () => {
    const h = biblioteca.toH()
    expect(h.id).toBe("biblioteca_dominio")
    expect(h.custo).toBe(10)
  })

  it("supports a prerequisito", () => {
    const castelo = new ConstrucaoDominio({ id: "castelo", name: "Castelo", categoria: "nobreza", prerequisito: "forte" })
    expect(castelo.prerequisito).toBe("forte")
  })
})
