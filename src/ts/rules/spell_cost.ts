/**
 * Spell PM cost rules (Tormenta20 core rules, Tabela 4-1: Custo de Magias).
 */
const COSTS_BY_CIRCLE: Record<number, number> = { 1: 1, 2: 3, 3: 6, 4: 10, 5: 15 }

export const SpellCost = {
  /**
   * Returns the base PM cost for a spell of the given circle.
   *
   * @param circle - the spell's circle (1-5)
   * @returns PM cost, or `undefined` if the circle is unknown
   *
   * @example
   * ```ts
   * SpellCost.forCircle(3) // 6
   * SpellCost.forCircle("4") // 10
   * ```
   */
  forCircle(circle: string | number): number | undefined {
    return COSTS_BY_CIRCLE[Number(circle)]
  },
}
