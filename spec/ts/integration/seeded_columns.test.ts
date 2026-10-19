import { describe, it, expect } from "vitest"
import { Ameaca } from "../../../src/ts/models/ameaca.js"
import { Arma } from "../../../src/ts/models/arma.js"
import { Armadura } from "../../../src/ts/models/armadura.js"
import { Escudo } from "../../../src/ts/models/escudo.js"
import { Item } from "../../../src/ts/models/item.js"
import { Magia } from "../../../src/ts/models/magia.js"
import { MaterialEspecial } from "../../../src/ts/models/material_especial.js"
import { Melhoria } from "../../../src/ts/models/melhoria.js"
import { Poder } from "../../../src/ts/models/poder.js"

// Columns whose source JSON key differs from the column name, or whose JSON value can be a bare string.
describe("seeded columns", () => {
  it("ameaca string-valued JSON columns round-trip", () => {
    expect(Ameaca.find("defeituoso")!.curaAcelerada).toBe("15/especial")
    expect(Ameaca.find("goblin_de_ferro_mark_ii")!.reducaoDeDano).toBe("20/corte_impacto_perfuração")
    expect(Ameaca.find("tentacute")!.familiar).toMatch(/^Um tentacute familiar/)
  })

  it("armadura and escudo read penalidade_armadura and especial", () => {
    const quitina = Armadura.find("armadura_de_quitina")!
    expect(quitina.armorPenalty).toBe(-3)
    expect(Armadura.find("armadura_acolchoada")!.properties).toEqual([{ bonus_fortitude: 2 }])
    expect(Escudo.find("escudo_leve")!.armorPenalty).toBe(-1)
    expect(Escudo.find("escudo_leve")!.properties).not.toEqual([])
  })

  it("arma properties include especial alongside habilidades", () => {
    const chicote = Arma.find("chicote")!
    expect(chicote.properties).toContain("agil")
    expect(chicote.properties.some((p) => typeof p === "object")).toBe(true)
  })

  it("item reads categoria and keeps non-base keys as effects", () => {
    const banho = Item.find("banho_quente")!
    expect(banho.category).toBe("servico")
    expect(banho.toH().effects).toHaveProperty("efeito")
  })

  it("magia extracts extra_costs", () => {
    expect(Magia.find("viagem_planar")!.extraCostsInfo()).toMatchObject({ material_cost: "T$ 1.000" })
    expect(Magia.find("roubar_a_alma")!.extraCostsInfo()).toHaveProperty("pm_sacrifice")
  })

  it("material especial reads precos_adicionais; melhoria categoria is a flat list", () => {
    expect(MaterialEspecial.find("adamante")!.priceModifier).toHaveProperty("arma", 3000)
    expect(Melhoria.find("inscrito")!.applicableTo).toEqual(["arma", "armadura", "escudo", "ferramenta", "vestuario"])
  })

  it("poder keeps costs and string-valued effects", () => {
    expect(Poder.find("barreira_mistica")!.costs).toEqual([{ value: 1, type: "PM" }])
    expect(Poder.find("martir")!.effects).toBe("ver_texto")
  })
})
