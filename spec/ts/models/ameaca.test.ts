import { describe, it, expect } from "vitest"
import { Ameaca } from "../../../src/ts/models/ameaca.js"

describe("Ameaca", () => {
  describe("data integrity", () => {
    it("has ameacas loaded from the database", () => {
      expect(Ameaca.count()).toBeGreaterThan(0)
    })

    it("every ameaca has required fields", () => {
      for (const a of Ameaca.all()) {
        expect(a.id).toBeTruthy()
        expect(a.name).toBeTruthy()
        expect(a.grupo).toBeTruthy()
        expect(typeof a.nd).toBe("number")
        expect(a.tamanho).toBeTruthy()
      }
    })

    it("every ameaca has structured ataques", () => {
      for (const a of Ameaca.all()) {
        expect(Array.isArray(a.ataques)).toBe(true)
        for (const atk of a.ataques as Record<string, unknown>[]) {
          expect(atk).toHaveProperty("nome")
          expect(atk).toHaveProperty("bonus")
          // dano is an array of damage components; null for maneuvers/special attacks
          if (atk.dano != null) {
            const components = atk.dano as Array<Record<string, unknown>>
            expect(Array.isArray(components)).toBe(true)
            expect(components.length).toBeGreaterThan(0)
            for (const comp of components) {
              expect(Array.isArray(comp.dados)).toBe(true)
            }
          }
        }
      }
    })

    it("salvaguardas have fort, ref and von", () => {
      for (const a of Ameaca.all()) {
        const s = a.salvaguardas
        expect(s).toHaveProperty("fort")
        expect(s).toHaveProperty("ref")
        expect(s).toHaveProperty("von")
      }
    })
  })

  describe("find", () => {
    it("returns the correct ameaca by id", () => {
      const basilisco = Ameaca.find("basilisco")
      expect(basilisco).not.toBeNull()
      expect(basilisco!.name).toBe("Basilisco")
      expect(basilisco!.nd).toBe(4)
      expect(basilisco!.grupo).toBe("ermos")
    })

    it("returns null for unknown id", () => {
      expect(Ameaca.find("nonexistent")).toBeNull()
    })
  })

  describe("scopes", () => {
    it("byGrupo returns only ameacas of that group", () => {
      const dragoes = Ameaca.byGrupo("dragoes").all()
      expect(dragoes.length).toBeGreaterThan(0)
      dragoes.forEach((a) => expect(a.grupo).toBe("dragoes"))
    })

    it("byNd returns only ameacas with exact nd", () => {
      const result = Ameaca.byNd(1).all()
      expect(result.length).toBeGreaterThan(0)
      result.forEach((a) => expect(a.nd).toBe(1))
    })

    it("upToNd returns ameacas with nd <= given value", () => {
      const result = Ameaca.upToNd(2).all()
      expect(result.length).toBeGreaterThan(0)
      result.forEach((a) => expect(a.nd).toBeLessThanOrEqual(2))
    })

    it("avatares returns only ameacas in the avatares group", () => {
      const avatares = Ameaca.avatares().all()
      expect(avatares.length).toBe(20)
      avatares.forEach((a) => expect(a.grupo).toBe("avatares"))
    })
  })

  describe("instance methods", () => {
    it("atributos returns all six attribute modifiers", () => {
      const a = Ameaca.find("basilisco")!
      const attrs = a.atributos
      expect(attrs).toHaveProperty("for")
      expect(attrs).toHaveProperty("des")
      expect(attrs).toHaveProperty("con")
      expect(attrs).toHaveProperty("int")
      expect(attrs).toHaveProperty("sab")
      expect(attrs).toHaveProperty("car")
    })

    it("toH returns a plain object with all expected keys", () => {
      const a = Ameaca.first()!
      const h = a.toH()
      expect(h).toMatchObject({
        id: a.id,
        name: a.name,
        nd: a.nd,
        grupo: a.grupo,
        tamanho: a.tamanho,
      })
    })

    it("poderesEspeciais is an array", () => {
      const a = Ameaca.find("basilisco")!
      expect(Array.isArray(a.poderesEspeciais)).toBe(true)
      expect(a.poderesEspeciais.length).toBeGreaterThan(0)
    })
  })

  describe("nd values", () => {
    it("fractional nd creatures exist (ND 1/4 = 0.25, ND 1/2 = 0.5)", () => {
      expect(Ameaca.byNd(0.25).count()).toBeGreaterThan(0)
      expect(Ameaca.byNd(0.5).count()).toBeGreaterThan(0)
    })

    it("dragao_rei has nd 20", () => {
      expect(Ameaca.find("dragao_rei")!.nd).toBe(20)
    })

    it("dragao_filhote has nd 3 with correct stats", () => {
      const filhote = Ameaca.find("dragao_filhote")!
      expect(filhote.nd).toBe(3)
      expect(filhote.pv).toBe(140)
      expect(filhote.defesa).toBe(22)
    })
  })

  describe("cura_acelerada and resistencia_a_magia (previously dropped by the seeder)", () => {
    it("vampiro has cura_acelerada and dragao_adulto has resistencia_a_magia", () => {
      expect(Ameaca.find("vampiro")!.curaAcelerada).toBe(10)
      expect(Ameaca.find("dragao_adulto")!.resistenciaAMagia).toBe(3)
    })

    it("avatar_de_megalokk has a string cura_acelerada with an exception", () => {
      expect(Ameaca.find("avatar_de_megalokk")!.curaAcelerada).toBe("100/kaiju")
    })
  })

  describe("familiar and parceiro", () => {
    it("bogum has a tiered parceiro and no familiar", () => {
      const bogum = Ameaca.find("bogum")!
      expect(bogum.parceiro).toHaveProperty("iniciante")
      expect(bogum.parceiro).toHaveProperty("veterano")
      expect(bogum.parceiro).toHaveProperty("mestre")
      expect(bogum.familiar).toBeNull()
    })

    it("homunculo has both familiar and parceiro", () => {
      const homunculo = Ameaca.find("homunculo")!
      expect(homunculo.familiar).toBeTruthy()
      expect(homunculo.parceiro).toHaveProperty("iniciante")
    })
  })
})
