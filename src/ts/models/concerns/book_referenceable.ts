import { database } from "../../database.js"

/**
 * A resolved book reference — the page where a record appears in a T20 sourcebook.
 */
export interface BookReference {
  /** Full book name (e.g. `"Tormenta20 - Jogo de Aventuras Fantásticas"`). */
  livro: string
  /** Page number. */
  pagina: number
  /** Human-readable label, e.g. `"T20JAF, p. 42"`. */
  formatted: string
}

/**
 * Looks up the book and page for a given record ID via the `indice_remissivo` table.
 *
 * @param registroId - The record's string ID (e.g. `"espada_longa"`)
 * @returns The `BookReference`, or `null` if the record has no index entry
 *
 * @example
 * ```ts
 * const ref = getBookReference("espada_longa")
 * // => { livro: "...", pagina: 126, formatted: "T20JAF, p. 126" }
 * ```
 */
export function getBookReference(registroId: string): BookReference | null {
  const row = database.db
    .prepare(
      `SELECT ir.pagina, l.nome, l.nome_curto
       FROM indice_remissivo ir
       JOIN livros l ON l.id = ir.livro_id
       WHERE ir.registro_id = ?
       LIMIT 1`
    )
    .get(registroId) as { pagina: number; nome: string; nome_curto: string } | undefined

  if (!row) return null

  return {
    livro: row.nome,
    pagina: row.pagina,
    formatted: `${row.nome_curto}, p. ${row.pagina}`,
  }
}
