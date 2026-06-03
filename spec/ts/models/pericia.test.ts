import { describe, it, expect } from "vitest"
import { Pericia } from "../../../src/ts/models/pericia.js"

describe("Pericia", () => {
  it("has pericias loaded", () => {
    expect(Pericia.count()).toBeGreaterThan(0)
  })

  it("boolean fields are properly coerced", () => {
    for (const p of Pericia.all()) {
      expect(typeof p.trainedOnly).toBe("boolean")
      expect(typeof p.armorPenalty).toBe("boolean")
      expect(typeof p.resistanceSkill).toBe("boolean")
    }
  })

  it("trainedOnlySkills returns only trained-only pericias", () => {
    const result = Pericia.trainedOnlySkills().all()
    expect(result.length).toBeGreaterThan(0)
    result.forEach((p) => expect(p.trainedOnly).toBe(true))
  })

  it("resistanceSkills returns saving-throw pericias", () => {
    const result = Pericia.resistanceSkills().all()
    expect(result.length).toBeGreaterThan(0)
    result.forEach((p) => expect(p.resistanceSkill).toBe(true))
  })

  it("byAtributo filters correctly", () => {
    const car = Pericia.byAtributo("CAR").all()
    car.forEach((p) => expect(p.atributo).toBe("CAR"))
  })
})
