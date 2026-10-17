const STEPS = ["menos_2", "menos_1", "normal", "mais_1", "mais_2", "mais_3"] as const

type StepRow = Record<(typeof STEPS)[number], string>

const TABLE: StepRow[] = [
  { menos_2: "1", menos_1: "1d2", normal: "1d3", mais_1: "1d4", mais_2: "1d6", mais_3: "1d8" },
  { menos_2: "1d2", menos_1: "1d3", normal: "1d4", mais_1: "1d6", mais_2: "1d8", mais_3: "1d10" },
  { menos_2: "1d3", menos_1: "1d4", normal: "1d6", mais_1: "1d8", mais_2: "1d10", mais_3: "1d12" },
  { menos_2: "1d4", menos_1: "1d6", normal: "1d8", mais_1: "1d10", mais_2: "1d12", mais_3: "3d6" },
  { menos_2: "1d6", menos_1: "1d8", normal: "1d10", mais_1: "1d12", mais_2: "3d6", mais_3: "4d6" },
  { menos_2: "1d8", menos_1: "1d10", normal: "1d12", mais_1: "3d6", mais_2: "4d6", mais_3: "4d8" },
  { menos_2: "1d10", menos_1: "2d6", normal: "2d8", mais_1: "3d8", mais_2: "4d8", mais_3: "4d10" },
  { menos_2: "2d6", menos_1: "2d8", normal: "2d10", mais_1: "3d10", mais_2: "4d10", mais_3: "4d12" },
]

/**
 * Damage step rules for weapon damage dice (Tormenta20 core rules, Tabela: Passos de Dano).
 *
 * Effects that increase or decrease weapon damage "by steps" move the damage die
 * along a fixed progression, from -2 to +3 steps relative to the weapon's normal die.
 */
export const DamageStep = {
  /**
   * Returns the damage die after shifting it a number of steps up or down.
   *
   * @param dice - the weapon's current normal damage die (e.g. "1d8")
   * @param steps - steps to shift, positive (up) or negative (down); clamped to the table's range (-2 to +3)
   * @returns the resulting die, or `undefined` if `dice` isn't a known normal damage die
   *
   * @example
   * ```ts
   * DamageStep.adjust("1d8", 2) // "1d12"
   * DamageStep.adjust("1d8", -1) // "1d6"
   * ```
   */
  adjust(dice: string, steps: number): string | undefined {
    const row = TABLE.find((r) => r.normal === dice)
    if (!row) return undefined

    const clamped = Math.max(-2, Math.min(3, steps))
    return row[STEPS[clamped + 2]]
  },
}
