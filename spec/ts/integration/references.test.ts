import { describe, it, expect } from "vitest"
import { Divindade } from "../../../src/ts/models/divindade.js"
import { Poder } from "../../../src/ts/models/poder.js"
import { ItemLiturgico } from "../../../src/ts/models/item_liturgico.js"
import { Classe } from "../../../src/ts/models/classe.js"

// Cross-table referential integrity checks.
//
// Several tables reference records in other tables by id, stored as plain
// JSON (string or array of strings) rather than a SQL foreign key — a
// deliberate project convention that avoids rigid FKs for things like
// `poderes.deities` or `divindades.granted_powers`. Nothing else in the
// suite verifies these ids actually resolve, so a typo'd or renamed id
// would pass every other spec silently. This file is the one place that
// walks each cross-reference and asserts it points at something real.
//
// Deliberately NOT covered: `ameacas.equipamento`. Unlike the references
// below, it has never been an id reference — core-book entries store it as
// free-text display strings (e.g. "Machado de guerra cruel"), not ids, so
// there's no real id-shaped invariant to assert there.
describe("Cross-table references", () => {
  const divindadeIds = new Set(Divindade.all().map((d) => d.id))
  const poderIds = new Set(Poder.all().map((p) => p.id))

  describe("Poder.deities", () => {
    it("only references existing divindades", () => {
      const orphans: string[] = []
      for (const poder of Poder.all()) {
        for (const deityId of poder.deities) {
          if (!divindadeIds.has(deityId)) orphans.push(`${poder.id} -> ${deityId}`)
        }
      }
      expect(orphans).toEqual([])
    })
  })

  describe("Divindade.grantedPowers", () => {
    it("only references existing poderes", () => {
      const orphans: string[] = []
      for (const divindade of Divindade.all()) {
        for (const powerId of divindade.grantedPowers) {
          if (!poderIds.has(powerId)) orphans.push(`${divindade.id} -> ${powerId}`)
        }
      }
      expect(orphans).toEqual([])
    })
  })

  describe("ItemLiturgico.deities", () => {
    it("only references existing divindades", () => {
      const orphans: string[] = []
      for (const item of ItemLiturgico.all()) {
        for (const deityId of item.deities) {
          if (!divindadeIds.has(deityId)) orphans.push(`${item.id} -> ${deityId}`)
        }
      }
      expect(orphans).toEqual([])
    })
  })

  describe("Classe.abilities and .powers", () => {
    it("only reference existing poderes", () => {
      const orphans: string[] = []
      for (const classe of Classe.all()) {
        const ids = [...classe.abilities, ...classe.powers] as string[]
        for (const powerId of ids) {
          if (!poderIds.has(powerId)) orphans.push(`${classe.id} -> ${powerId}`)
        }
      }
      expect(orphans).toEqual([])
    })
  })
})
