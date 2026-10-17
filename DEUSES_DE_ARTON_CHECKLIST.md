# Deuses de Arton — checklist de implementação (COMPLETO)

> Este arquivo foi perdido por um glitch de ambiente (desapareceu do disco sem nunca ter sido
> commitado) e recriado nesta sessão a partir do histórico da conversa e verificação direta do
> estado real do código/banco. O conteúdo mecânico em si (JSONs, schema, models, specs) nunca foi
> perdido — só este arquivo de tracking.

**Deuses de Arton — implementação 100% completa** (Capítulos 1-4, todas as fases A-G).
Livro registrado: `deuses_de_arton`. 522 registros no total com esse `livro`.

## Fase A — Capítulo 1, regras pequenas
- `regras/devocao_ampla.json` (clérigo/frade do Panteão, druida de Arton, paladino do bem
  trocam poderes concedidos por +2 PM/patamar).
- Autoridade Eclesiástica: 1 `poder_concedido` com `deities` listando as 20 divindades e
  `effects` como objeto chaveado por id de divindade.
- Outros Devotos: campo `devotees` atualizado nas 20 `divindades/*.json` existentes.
- Nova Linhagem: Abençoada (Feiticeiro), 3 níveis (Básica/Aprimorada/Superior).

## Fase B — Classe Frade
`src/json/classes/frade.json` completa: hit_points, mana_points, skills, proficiencies,
abilities, powers, progression, spellcasting.

## Fase C — Poderes Concedidos
`src/json/poderes/poderes_concedidos/*.json` — ~75 arquivos, `type: poder_concedido`,
campo `deities`. Inclui `ser_nimb.json` (renomeado de "nimb" por colisão de id com a
divindade) e `dom_da_vontade.json`.

## Fase D — Itens Litúrgicos + Equipamentos Religiosos
- Tabela nova `itens_liturgicos` (35 registros): `db/schema.sql`, `bin/build_db`
  (`seed_itens_liturgicos`), `src/ruby/tormenta20/seeder.rb`, model Ruby
  (`item_liturgico.rb`) + TS (`item_liturgico.ts`) + specs dos dois lados. Campo
  `deities JSON` (array, sem FK rígida).
- Melhorias de itens superiores (`melhorias/{armas,geral}/*.json`): conduite, diligente,
  inscrito, canonico, devotado.
- Equipamentos em `equipamentos/itens/{aventura,ferramentas,vestuario,esotericos,
  alquimicos/{preparados,catalisadores},alimentacao,servicos}/*.json` (69 arquivos).

## Fase E — Magias Divinas
25 magias novas em `src/json/magias/*.json`, formato padrão do projeto.

## Fase F — Deuses e Avatares (Capítulo 3)
- 20 `ameacas/avatares/*.json` (um por divindade maior), `grupo: "avatares"`, nome
  `"Avatar de <Divindade>"`. Casos notáveis: `avatar_de_nimb.json` (atributos.sab e
  percepção null, mecânica de piada 1d20 documentada em `poderes_especiais`),
  `avatar_de_megalokk.json` (`cura_acelerada: "100/kaiju"`, forma string excepcional).
- Correção de convenção: todos os 20 avatares usam o campo top-level `resistencia_a_magia`
  (não `resistencias.magia`), igual ao padrão legado (Dragão Adulto).
- 6 Aspectos dos Deuses (confirmado por releitura do livro — não são 7 como uma suposição
  inicial havia assumido; o "7º" era só o sidebar de lore "Aspectos e Avatares", sem stat block).
- Deuses Menores: 3 novas divindades (`gwendolynn.json`, `mauziell.json`, `tibar.json`) com
  `rank: "menor"`, `natureza`, `status_divino` — 2 colunas novas em `divindades`
  (`rank TEXT DEFAULT 'maior' CHECK(rank IN ('maior','menor'))`, `natureza TEXT`,
  `status_divino INTEGER`).
- Artefatos Divinos: 19 novos `itens_magicos/artefatos/*.json` (ex.: `kaminari.json`,
  `rhumnam.json`, `holy_avenger.json`, `belo_presente_adaga.json` — renomeado para evitar
  colisão de id com o poder `belo_presente` da Fase C).
- "Os Antigos Deuses": confirmado lore puro, fora do escopo.

## Fase G — Ameaças Divinas (Capítulo 4)
- **Abissais (10)**, `grupo: "abissais"`: Diabrete, Diabrete Negociante, Trio de Carvarel
  (variante "bando" de 3 — o carvarel individual já existe como `guerreiro_de_chifres` no
  core EJA), Aucharai, Rhayrivel, Súcubo, Jhumariel, Margharon, Abahddon, Lamashtu. Mais o
  item alquímico `saliva_acida` e o artefato `kazidhaan`.
- **Celestiais (12)**, `grupo: "celestiais"`: Pilly, Luminar (sem ND numérico no livro — usado
  `nd: 1` como estimativa editorial documentada na description), Protetor, Shiradi,
  Fado/Probo/Parcus (os 3 "inevitáveis", regra compartilhada `regras/inevitaveis.json`),
  Pégaso, Pégaso de Khalmyr, Muhir (com o artefato `armadura_dos_neladriel`), Orel, Fúria
  Extrema.
- **Fadas (12)**, `grupo: "fadas"`: Duende Menor, Sílfide Travessa, Sátiro Arqueiro, Náiade,
  Dríade, Dragonete, Duende Maior, Ninfa, Eiradaan Guardião, Sílfide Encantadora, Velha
  Bruxa, Eiradaan Nobre. Mais `regras/coriza_e_espirros.json`.
- **Gênios (6)**, `grupo: "genios"`: Jairuan, Kemooz, Yazzu, Gizzehi, Allaraz, Dabbus. Regra
  compartilhada `regras/genios.json`.
- **Gigantes (10)**, `grupo: "gigantes"`: Galokk Capanga, Galokk Guarda-Costas, Gigante das
  Colinas, Gigante do Fogo, Gigante das Rochas/Gelo/Mares (variantes regionais, regra
  compartilhada `regras/barril_gigante.json`), Gigante Bicéfalo, Gigante Real, Gigante Máximo
  (mecânica única "Grande Demais" — sem PV único, 4 partes do corpo com PV/CD/dano de queda
  próprios, `pv: null`). Mais `regras/bolsas_de_gigante.json`.
- **Perigos Complexos**: `regras/perigos_complexos.json` (Vento Abrasador ND 3, Pântano
  Amaldiçoado ND 5, Cataclismo ND 17).
- Bug pré-existente corrigido: seeder de `ameacas` descartava silenciosamente
  `cura_acelerada`/`resistencia_a_magia` por falta de coluna — 2 colunas novas adicionadas +
  wiring completo nos dois seeders (Ruby `bin/build_db` e nativo `seeder.rb`) + TS
  `seeder.ts` (que tinha um gap ainda maior, nunca escrevia vários campos de `ameacas`).
- Total de `ameacas` no banco: 156 (80 pré-existentes do EJA + 20 avatares + 6 aspectos + 50
  desta fase).

## Pós-implementação: suíte de integridade referencial

Adicionado `spec/ruby/integration/references_spec.rb` + `spec/ts/integration/references.test.ts`:
verifica que `poderes.deities`, `divindades.granted_powers`, `itens_liturgicos.deities` e
`classes.abilities`/`classes.powers` só apontam para ids que realmente existem (JSON solto, sem
FK, por convenção do projeto). Deliberadamente não cobre `ameacas.equipamento` (confirmado:
nunca foi id-reference, é texto livre em todo o projeto).

Pegou 8 bugs pré-existentes reais (não relacionados a Deuses de Arton) em
`classes.abilities`/`classes.powers`, todos corrigidos:
- `bucaneiro`: 3 poderes com filename correto mas `"id"` interno typo'd (`insolenica`→
  `insolencia`, `esquiva_sagz`→`esquiva_sagaz`, `amigo_do_porto`→`amigos_do_porto`).
- `bardo`, `inventor`, `ladino`, `lutador`, `paladino`: 5 poderes com filename typo'd mas
  `"id"` interno correto — arquivos renomeados via `git mv`
  (`ispiracao_marcial.json`→`inspiracao_marcial.json`, `propotipo.json`→`prototipo.json`,
  `a_pessoa_ceerta_para_o_trabalho.json`→`a_pessoa_certa_para_o_trabalho.json`,
  `sequencia_desrtuidora.json`→`sequencia_destruidora.json`,
  `aura_atimagia.json`→`aura_antimagia.json`); as classes também referenciavam a grafia
  errada e tiveram que ser corrigidas junto.

Verificação final: 419 RSpec + 262 Vitest, 0 falhas, RuboCop limpo.

**Achado separado, não corrigido, fora de escopo**: `src/json/equipamentos/escudos/
broquel.json` (item de `herois_de_arton`) tem `bonus_defesa: null` (correto — o broquel não
dá o bônus de Defesa normal), mas `escudos.defense_bonus` é `NOT NULL`, então o import desse
registro falha a cada `bin/build_db`. Decisão do usuário pendente (relaxar a constraint ou
tratar de outra forma).

*(Fim do trabalho planejado para Deuses de Arton. Próximo suplemento: Ameaças de Arton.)*
