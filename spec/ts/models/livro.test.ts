import { describe, it, expect } from "vitest"
import { Livro } from "../../../src/ts/models/livro.js"

describe("Livro", () => {
  it("has livros loaded", () => {
    expect(Livro.count()).toBeGreaterThan(0)
  })

  it("every livro has name and nomeCurto", () => {
    for (const l of Livro.all()) {
      expect(l.name).toBeTruthy()
      expect(l.nomeCurto).toBeTruthy()
    }
  })

  it("toH returns nome and nome_curto", () => {
    const l = Livro.first()!
    const h = l.toH()
    expect(h.nome).toBe(l.name)
    expect(h.nome_curto).toBe(l.nomeCurto)
  })
})
