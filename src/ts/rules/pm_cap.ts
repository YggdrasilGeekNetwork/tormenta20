/**
 * Rules utilities for PM (Mana Points) cap calculations.
 */
export const PmCap = {
  /**
   * Returns the effective PM cap for a class ability or power.
   *
   * When a power's PM cost scales with a specific class level (e.g. Arcanista's
   * Magia Aprimorada), the cap is the character's level in that class. Otherwise
   * it falls back to the total character level.
   *
   * @param params.characterLevel - Total character level (sum of all class levels)
   * @param params.classLevel - Character's level in the class that provides the ability, or `null`
   * @param params.sourceClass - ID of the class that provides the ability, or `null`
   * @returns The PM cap as an integer
   *
   * @example
   * ```ts
   * PmCap.forAbility({ characterLevel: 10, classLevel: 6, sourceClass: "arcanista" }) // 6
   * PmCap.forAbility({ characterLevel: 10, classLevel: null, sourceClass: null })      // 10
   * ```
   */
  forAbility(params: {
    characterLevel: number
    classLevel?: number | null
    sourceClass?: string | null
  }): number {
    const { characterLevel, classLevel, sourceClass } = params
    if (sourceClass == null || classLevel == null) return characterLevel
    return classLevel
  },
}
