import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "indice_remissivo"

/**
 * An entry in the Índice Remissivo (book index) — maps terms to page numbers in T20 sourcebooks.
 *
 * Entries with a `registroId` are linked to a specific record in another table,
 * enabling the `bookReference()` feature on models.
 *
 * @example
 * ```ts
 * IndiceRemissivo.doLivro("t20jaf").all()
 * IndiceRemissivo.buscarTermo("espada").all()
 * IndiceRemissivo.associados().count()    // entries linked to model records
 * IndiceRemissivo.naoAssociados().all()   // entries without a matching record
 * ```
 */
export class IndiceRemissivo extends BaseModel {
  /** ID of the {@link Livro} this entry belongs to. */
  get livroId(): string { return this._row.livro_id as string }
  /** The indexed term or title as it appears in the book's index. */
  get termo(): string { return this._row.termo as string }
  get pagina(): number { return this._row.pagina as number }
  /** Name of the database table this entry links to, or `null` for unlinked entries. */
  get tabela(): string | null { return (this._row.tabela as string) ?? null }
  /** ID of the linked record in `tabela`, or `null` for unlinked entries. */
  get registroId(): string | null { return (this._row.registro_id as string) ?? null }

  /** `true` if this entry is linked to a record in the database. */
  get associado(): boolean { return this.registroId !== null }

  toH() {
    return {
      id: this.id,
      livro_id: this.livroId,
      termo: this.termo,
      pagina: this.pagina,
      tabela: this.tabela,
      registro_id: this.registroId,
    }
  }

  static query(): Query<IndiceRemissivo> { return BaseModel.makeQuery(TABLE, IndiceRemissivo) }
  static all(): IndiceRemissivo[] { return IndiceRemissivo.query().all() }
  static find(id: string): IndiceRemissivo | null { return IndiceRemissivo.query().find(id) }
  static first(): IndiceRemissivo | null { return IndiceRemissivo.query().first() }
  static last(): IndiceRemissivo | null { return IndiceRemissivo.query().last() }
  static count(): number { return IndiceRemissivo.query().count() }

  /** Returns all index entries for a given book. */
  static doLivro(livroId: string): Query<IndiceRemissivo> {
    return IndiceRemissivo.query().where("livro_id = ?", livroId)
  }
  /** Returns index entries pointing to a specific table. */
  static paraTabela(tabela: string): Query<IndiceRemissivo> {
    return IndiceRemissivo.query().where("tabela = ?", tabela)
  }
  /** Returns entries that are linked to a record in another table. */
  static associados(): Query<IndiceRemissivo> {
    return IndiceRemissivo.query().where("registro_id IS NOT NULL")
  }
  /** Returns entries with no linked record. */
  static naoAssociados(): Query<IndiceRemissivo> {
    return IndiceRemissivo.query().where("registro_id IS NULL")
  }
  /**
   * Returns entries whose term contains the search string (case-insensitive).
   *
   * @param q - Substring to search for
   */
  static buscarTermo(q: string): Query<IndiceRemissivo> {
    return IndiceRemissivo.query().where("termo LIKE ?", `%${q}%`)
  }
}
