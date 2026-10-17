import { describe, it, expect } from "vitest"
import { Divindade } from "../../../src/ts/models/divindade.js"

describe("Divindade", () => {
  it("has divindades loaded", () => {
    expect(Divindade.count()).toBeGreaterThan(0)
  })

  it("every divindade has id and name", () => {
    for (const d of Divindade.all()) {
      expect(d.id).toBeTruthy()
      expect(d.name).toBeTruthy()
      expect(["positiva", "negativa", "qualquer"]).toContain(d.energy)
    }
  })

  describe("find", () => {
    it("returns allihanna with correct energy", () => {
      const d = Divindade.find("allihanna")
      expect(d).not.toBeNull()
      expect(d!.energy).toBe("positiva")
      expect(d!.grantedPowers.length).toBeGreaterThan(0)
    })
  })

  describe("scopes", () => {
    it("energiaPositiva returns only positiva", () => {
      Divindade.energiaPositiva().all().forEach((d) => expect(d.energy).toBe("positiva"))
    })

    it("energiaNegativa returns only negativa", () => {
      Divindade.energiaNegativa().all().forEach((d) => expect(d.energy).toBe("negativa"))
    })

    it("energiaQualquer returns only qualquer", () => {
      Divindade.energiaQualquer().all().forEach((d) => expect(d.energy).toBe("qualquer"))
    })

    it("maiores and menores split by rank", () => {
      expect(Divindade.maiores().all().length).toBeGreaterThan(0)
      Divindade.maiores().all().forEach((d) => expect(d.rank).toBe("maior"))
      expect(Divindade.menores().all().length).toBeGreaterThan(0)
      Divindade.menores().all().forEach((d) => expect(d.rank).toBe("menor"))
    })
  })

  describe("deuses menores (Deuses de Arton)", () => {
    it("tibar is a minor deity with natureza and status_divino", () => {
      const tibar = Divindade.find("tibar")!
      expect(tibar.rank).toBe("menor")
      expect(tibar.natureza).toBe("mortal_ascendido")
      expect(tibar.statusDivino).toBe(5)
    })

    it("khalmyr (major deity) defaults to rank maior with no natureza", () => {
      const khalmyr = Divindade.find("khalmyr")!
      expect(khalmyr.rank).toBe("maior")
      expect(khalmyr.natureza).toBeNull()
    })
  })

  describe("instance methods", () => {
    it("races returns an array", () => {
      const d = Divindade.find("allihanna")!
      expect(Array.isArray(d.races())).toBe(true)
    })

    it("classes returns an array", () => {
      const d = Divindade.find("allihanna")!
      expect(Array.isArray(d.classes())).toBe(true)
    })

    it("toH includes all keys", () => {
      const d = Divindade.first()!
      const h = d.toH()
      expect(h).toMatchObject({ id: d.id, name: d.name, energy: d.energy })
    })
  })
})
