import { describe, it, expect } from "vitest"
import { ClasseVariante } from "../../../src/ts/models/classe_variante.js"
import { Classe } from "../../../src/ts/models/classe.js"

describe("ClasseVariante", () => {
  it("has classes_variantes loaded", () => {
    expect(ClasseVariante.count()).toBeGreaterThan(0)
  })

  it("every variant has id, name, base_class_id and a non-empty diffs array", () => {
    for (const v of ClasseVariante.all()) {
      expect(v.id).toBeTruthy()
      expect(v.name).toBeTruthy()
      expect(v.baseClassId).toBeTruthy()
      expect(Array.isArray(v.diffs)).toBe(true)
      expect(v.diffs.length).toBeGreaterThan(0)
    }
  })

  it("resolves to the base Classe record", () => {
    const duelista = ClasseVariante.find("duelista")!
    const base = Classe.find(duelista.baseClassId)
    expect(base).not.toBeNull()
    expect(base!.id).toBe("bucaneiro")
  })

  it("byBase returns only variants built on the given base class", () => {
    ClasseVariante.byBase("bucaneiro").all().forEach((v) => expect(v.baseClassId).toBe("bucaneiro"))
  })

  it("each diff entry has nivel, remove and adiciona keys", () => {
    const duelista = ClasseVariante.find("duelista")!
    for (const diff of duelista.diffs as Record<string, unknown>[]) {
      expect(diff).toHaveProperty("nivel")
      expect(diff).toHaveProperty("remove")
      expect(diff).toHaveProperty("adiciona")
    }
  })

  it("toH returns all fields", () => {
    const v = ClasseVariante.first()!
    const h = v.toH()
    expect(h).toMatchObject({ id: v.id, name: v.name, base_class_id: v.baseClassId })
    expect(h.diffs).toBeDefined()
  })
})
