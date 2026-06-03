/**
 * @packageDocumentation
 *
 * TypeScript/Node.js library for querying Tormenta20 TTRPG data.
 *
 * Provides typed model classes backed by a bundled SQLite database.
 * All models share a lazy-initialised connection via {@link database}.
 *
 * @example
 * ```ts
 * import { Arma, Magia, Poder, Classe } from "tormenta20"
 *
 * Arma.marciais().all()
 * Magia.arcanas().where("circle = ?", "3").all()
 * Poder.poderesCombate().all()
 * Classe.find("guerreiro")?.initialHp  // 20
 * ```
 */

export { database } from "./database.js"
export { Query } from "./query.js"

export { Origem } from "./models/origem.js"
export { Poder } from "./models/poder.js"
export { Divindade } from "./models/divindade.js"
export { Classe } from "./models/classe.js"
export { Magia } from "./models/magia.js"
export { Arma } from "./models/arma.js"
export { Armadura } from "./models/armadura.js"
export { Escudo } from "./models/escudo.js"
export { Item } from "./models/item.js"
export { MaterialEspecial } from "./models/material_especial.js"
export { Encantamento } from "./models/encantamento.js"
export { Melhoria } from "./models/melhoria.js"
export { Regra } from "./models/regra.js"
export { Raca } from "./models/raca.js"
export { Condicao } from "./models/condicao.js"
export { Livro } from "./models/livro.js"
export { Pericia } from "./models/pericia.js"
export { Tabela } from "./models/tabela.js"
export { IndiceRemissivo } from "./models/indice_remissivo.js"
export { Pocao } from "./models/pocao.js"
export { AcessorioMagico } from "./models/acessorio_magico.js"

export { PmCap } from "./rules/pm_cap.js"
export { seed } from "./seeder.js"

export type { BookReference } from "./models/concerns/book_referenceable.js"
export type { PoderType } from "./models/poder.js"
export type { MagiaType, MagiaSchool } from "./models/magia.js"
export type { ArmaCategory, DamageType } from "./models/arma.js"
export type { ArmaduraCategory } from "./models/armadura.js"
export type { DivindadeEnergy } from "./models/divindade.js"
export type { RacaSize, RacaVision } from "./models/raca.js"
export type { CondicaoType } from "./models/condicao.js"
export type { PericiaAtributo } from "./models/pericia.js"
export type { EncantamentoCategoria } from "./models/encantamento.js"
