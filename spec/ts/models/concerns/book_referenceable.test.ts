import { describe, it, expect } from "vitest"
import { getBookReference } from "../../../../src/ts/models/concerns/book_referenceable.js"
import { IndiceRemissivo } from "../../../../src/ts/models/indice_remissivo.js"

describe("getBookReference", () => {
  it("returns null when no index entry exists for the id", () => {
    expect(getBookReference("this_id_does_not_exist_anywhere")).toBeNull()
  })

  it("returns the page and a formatted label ending in the page number", () => {
    const entry = IndiceRemissivo.associados().first()!
    const ref = getBookReference(entry.registroId!)

    expect(ref).not.toBeNull()
    expect(ref!.pagina).toBe(entry.pagina)
    expect(ref!.formatted.endsWith(`, p. ${entry.pagina}`)).toBe(true)
  })

  it("livro holds the full book name backing the formatted short label", () => {
    const entry = IndiceRemissivo.associados().first()!
    const ref = getBookReference(entry.registroId!)!

    expect(ref.livro.length).toBeGreaterThan(0)
    expect(ref.formatted.startsWith(ref.livro)).toBe(false) // formatted uses the short name, not the full one
  })
})
