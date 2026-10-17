import { BaseModel } from "./base.js"
import { Query } from "../query.js"

const TABLE = "ameacas"

/**
 * A threat (monster/enemy) stat block from Tormenta20 (Cap. 7).
 *
 * @example
 * ```ts
 * Ameaca.all()
 * Ameaca.byGrupo("dragoes").orderBy("nd").all()
 * Ameaca.find("basilisco")
 * ```
 */
export class Ameaca extends BaseModel {
  /** Challenge rating (Nível de Desafio). */
  get nd(): number { return this._row.nd as number }
  /** Creature type (e.g. `"animal"`, `"morto-vivo"`). */
  get tipo(): string | null { return (this._row.tipo as string) ?? null }
  /** Creature subtype, if any. */
  get subtipo(): string | null { return (this._row.subtipo as string) ?? null }
  /** Size category (e.g. `"médio"`, `"grande"`). */
  get tamanho(): string { return this._row.tamanho as string }
  /** Thematic group for browsing (e.g. `"dragoes"`, `"ermos"`). */
  get grupo(): string { return this._row.grupo as string }
  /** Hit points. */
  get pv(): number | null { return (this._row.pv as number) ?? null }
  /** Defense value. */
  get defesa(): number | null { return (this._row.defesa as number) ?? null }
  /** Força (Strength). Uses bracket access because `for` is a JS reserved word. */
  get forca(): number | null { return (this._row["for"] as number) ?? null }
  get des(): number | null { return (this._row.des as number) ?? null }
  get con(): number | null { return (this._row.con as number) ?? null }
  get int(): number | null { return (this._row.int as number) ?? null }
  get sab(): number | null { return (this._row.sab as number) ?? null }
  get car(): number | null { return (this._row.car as number) ?? null }
  get iniciativa(): number | null { return (this._row.iniciativa as number) ?? null }
  get deslocamento(): string | null { return (this._row.deslocamento as string) ?? null }
  /** JSON object with saving throw bonuses (`{ fort, ref, von }`). */
  get salvaguardas(): Record<string, number> { return BaseModel.json(this._row.salvaguardas, {}) }
  get percepcao(): number | null { return (this._row.percepcao as number) ?? null }
  get visao(): string | null { return (this._row.visao as string) ?? null }
  /** JSON array of attack entries. */
  get ataques(): unknown[] { return BaseModel.json(this._row.ataques, []) }
  /** JSON array of special abilities. */
  get poderesEspeciais(): unknown[] { return BaseModel.json(this._row.poderes_especiais, []) }
  /** JSON array of immunity names. */
  get imunidades(): string[] { return BaseModel.json(this._row.imunidades, []) }
  /** JSON object of resistance amounts by damage type. */
  get resistencias(): Record<string, number> { return BaseModel.json(this._row.resistencias, {}) }
  /** JSON array of vulnerability names. */
  get vulnerabilidades(): string[] { return BaseModel.json(this._row.vulnerabilidades, []) }
  /** Damage reduction — a number (e.g. `10`) or a string with an exception (e.g. `"10/luz"`). */
  get reducaoDeDano(): number | string | null { return BaseModel.json(this._row.reducao_de_dano, null) }
  /** Fast healing — a number (e.g. `10`) or a string with an exception (e.g. `"100/kaiju"`). */
  get curaAcelerada(): number | string | null { return BaseModel.json(this._row.cura_acelerada, null) }
  /** Resistance to magic (bonus against spells targeting the creature), or `null`. */
  get resistenciaAMagia(): number | null { return (this._row.resistencia_a_magia as number) ?? null }
  /** JSON object of skill bonuses by skill name. */
  get pericias(): Record<string, number> { return BaseModel.json(this._row.pericias, {}) }
  /** JSON array of equipment item names. */
  get equipamento(): string[] { return BaseModel.json(this._row.equipamento, []) }
  get tesouro(): string | null { return (this._row.tesouro as string) ?? null }
  /** Mana points, for spellcasting creatures. */
  get pm(): number | null { return (this._row.pm as number) ?? null }
  get description(): string | null { return (this._row.description as string) ?? null }
  /** Simple spellcaster-familiar benefit (free text), or `null`. */
  get familiar(): string | null { return BaseModel.json(this._row.familiar, null) }
  /** JSON object with tiered companion ("parceiro especial") benefits: `{ tipo, restricao, iniciante, veterano, mestre }`. */
  get parceiro(): Record<string, unknown> | null { return BaseModel.json(this._row.parceiro, null) }

  /** Returns all 6 attributes as a plain object using standard T20 abbreviations. */
  get atributos() {
    return {
      // eslint-disable-next-line @typescript-eslint/naming-convention
      for: this.forca,
      des: this.des, con: this.con, int: this.int, sab: this.sab, car: this.car,
    }
  }

  toH() {
    return {
      id: this.id, name: this.name, nd: this.nd,
      tipo: this.tipo, subtipo: this.subtipo, tamanho: this.tamanho, grupo: this.grupo,
      pv: this.pv, defesa: this.defesa,
      atributos: this.atributos,
      iniciativa: this.iniciativa, deslocamento: this.deslocamento,
      salvaguardas: this.salvaguardas, percepcao: this.percepcao, visao: this.visao,
      ataques: this.ataques, poderes_especiais: this.poderesEspeciais,
      imunidades: this.imunidades, resistencias: this.resistencias,
      vulnerabilidades: this.vulnerabilidades, reducao_de_dano: this.reducaoDeDano,
      cura_acelerada: this.curaAcelerada, resistencia_a_magia: this.resistenciaAMagia,
      pericias: this.pericias, equipamento: this.equipamento,
      tesouro: this.tesouro, pm: this.pm,
      description: this.description,
      familiar: this.familiar, parceiro: this.parceiro,
    }
  }

  static query(): Query<Ameaca> { return BaseModel.makeQuery(TABLE, Ameaca) }
  static all(): Ameaca[] { return Ameaca.query().all() }
  static find(id: string): Ameaca | null { return Ameaca.query().find(id) }
  static first(): Ameaca | null { return Ameaca.query().first() }
  static last(): Ameaca | null { return Ameaca.query().last() }
  static count(): number { return Ameaca.query().count() }

  static byGrupo(grupo: string): Query<Ameaca> {
    return Ameaca.query().where("grupo = ?", grupo)
  }

  static avatares(): Query<Ameaca> { return Ameaca.byGrupo("avatares") }

  static byNd(nd: number): Query<Ameaca> {
    return Ameaca.query().where("nd = ?", nd)
  }

  static upToNd(nd: number): Query<Ameaca> {
    return Ameaca.query().where("nd <= ?", nd)
  }
}
