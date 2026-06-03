import { describe, it, expect } from "vitest"
import { Escudo } from "../../../src/ts/models/escudo.js"

describe("Escudo", () => {
  it("has escudos loaded", () => {
    expect(Escudo.count()).toBeGreaterThan(0)
  })

  it("every escudo has a positive defense_bonus", () => {
    for (const e of Escudo.all()) {
      expect(e.id).toBeTruthy()
      expect(e.name).toBeTruthy()
      expect(e.defenseBonus).toBeGreaterThan(0)
    }
  })

  it("toH returns all fields", () => {
    const e = Escudo.first()!
    const h = e.toH()
    expect(h).toMatchObject({ id: e.id, name: e.name, defense_bonus: e.defenseBonus })
  })
})
