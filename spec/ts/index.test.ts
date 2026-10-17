import { describe, it, expect } from "vitest"
import * as Tormenta20 from "../../src/ts/index.js"

describe("index", () => {
  it("exposes the public model classes", () => {
    expect(Tormenta20.Origem).toBeTypeOf("function")
    expect(Tormenta20.Poder).toBeTypeOf("function")
    expect(Tormenta20.Distincao).toBeTypeOf("function")
    expect(Tormenta20.Regra).toBeTypeOf("function")
  })

  it("Distincao is queryable from the public entry point", () => {
    expect(Tormenta20.Distincao.count()).toBeGreaterThan(0)
  })
})
