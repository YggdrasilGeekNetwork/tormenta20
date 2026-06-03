import { describe, it, expect } from "vitest"
import { Regra } from "../../../src/ts/models/regra.js"

describe("Regra", () => {
  it("data field is an object", () => {
    for (const r of Regra.all()) {
      expect(r.id).toBeTruthy()
      expect(r.name).toBeTruthy()
      expect(typeof r.data).toBe("object")
    }
  })

  it("toH returns data", () => {
    const r = Regra.first()
    if (!r) return
    const h = r.toH()
    expect(h).toMatchObject({ id: r.id, name: r.name })
    expect(h.data).toBeDefined()
  })
})
