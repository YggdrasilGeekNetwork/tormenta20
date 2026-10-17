import { describe, it, expect } from "vitest"
import { Classe } from "../../../src/ts/models/classe.js"
import { Poder } from "../../../src/ts/models/poder.js"
import { Ameaca } from "../../../src/ts/models/ameaca.js"
import { Encantamento } from "../../../src/ts/models/encantamento.js"
import { Livro } from "../../../src/ts/models/livro.js"

// Samples a few unrelated models to prove livroId + the livro_id column
// work generically via BaseModel, not per-model wiring.
const MODELS = [Classe, Poder, Ameaca, Encantamento]

describe("livro scoping", () => {
  it("every record's livroId resolves to a registered Livro", () => {
    const livroIds = new Set(Livro.all().map((l) => l.id))
    for (const Model of MODELS) {
      for (const record of Model.all() as { livroId: string }[]) {
        expect(livroIds.has(record.livroId)).toBe(true)
      }
    }
  })

  it("query().where('livro_id = ?', ...) partitions the table exactly", () => {
    for (const Model of MODELS) {
      const byBook = new Map<string, number>()
      for (const record of Model.all() as { livroId: string }[]) {
        byBook.set(record.livroId, (byBook.get(record.livroId) ?? 0) + 1)
      }
      let total = 0
      for (const [livroId, n] of byBook) {
        expect(Model.query().where("livro_id = ?", livroId).count()).toBe(n)
        total += n
      }
      expect(total).toBe(Model.count())
      expect(Model.query().where("livro_id = ?", "nonexistent_book").count()).toBe(0)
    }
  })

  it("livroId resolves to a real Livro record", () => {
    const classe = Classe.first()!
    const livro = Livro.find(classe.livroId)
    expect(livro).not.toBeNull()
    expect(livro!.nomeCurto).toBe("T20 - EJA")
  })
})
