# Ameaças de Arton — checklist de implementação (EM PROGRESSO)

Livro: `ameacas_de_arton` (a registrar na tabela `livros`). PDF fonte:
`/home/luan/arkheion/recursos/Ameacas-de-Arton-v1.0-17-11-2023.pdf` (436 páginas).
Plano completo em `/home/luan/.claude/plans/ethereal-brewing-wadler.md`.

## Fase A — Capítulo 2: Regras Avançadas de Ameaças ✅ completo
- [x] `regras/regras_adicionais_de_ameacas.json`: Criaturas e Ataques (Luta e Pontaria, Tipos e
      Dados de Dano, Armas Naturais + Tabela 2-1, Armas Empunhadas, Removendo Equipamentos),
      CD de Habilidades, Ameaças e Morte, Condições de Itens (Avariado/Destruído/Reparando),
      Parceiros de Ameaças, Recompensas por Vários Inimigos, Criaturas S/S+, Magias Sem
      Custo, Magias Simuladas.
- [x] `regras/manual_de_criacao_de_ameacas.json`: filosofia de criação, Passos 0-7 completos,
      Tabela 2-2 (Deslocamentos), Tabela 2-3 A/B/C (Parâmetros de Criaturas — Solo/Lacaio/
      Especial, todos os ND de 1/4 a S+), Tabela 2-4 (Categorias de Atributo), Como Modificar
      Criaturas, Como Criar Bandos.
- [x] Bônus: os 2 exemplos completos de criação do livro (Dejeto Vivo, Cardume de Aquin'ne)
      são stat blocks jogáveis reais, não só texto ilustrativo — adicionados como
      `ameacas/exemplos_de_criacao/dejeto_vivo.json` e `cardume_de_aquinne.json`
      (`grupo: "exemplos_de_criacao"`), referenciados de volta no campo `exemplos_de_criacao`
      do manual.
- [x] Livro `ameacas_de_arton` registrado em `src/json/livros/ameacas_de_arton.json`.
- Verificação: `bin/build_db` sem erros novos (só o bug pré-existente não relacionado do
  `broquel.json`), 419 RSpec + 262 Vitest, 0 falhas.

## Fase B — Mascotes & Familiares ✅ completo
- [x] Bogum, Escudeiro, Fofo, Gambá, Homúnculo, Kill'Bone, Tentacute (+ Tropa de Tentacutes,
      bando ND 2), Verilêmur, Malafex — 10 arquivos em `ameacas/mascotes_e_familiares/`.
- [x] Novo campo estrutural descoberto: "Parceiro" (benefícios de companheiro por patamar
      Iniciante/Veterano/Mestre) e "Familiar" (benefício simples de familiar de conjurador),
      presentes em quase toda esta seção. Adicionadas 2 colunas novas em `ameacas`
      (`familiar JSON`, `parceiro JSON`) com wiring completo (schema.sql, `bin/build_db`,
      `seeder.rb` nativo, model Ruby `to_h`, model TS `familiar`/`parceiro` getters +
      `seeder.ts`, specs dos dois lados usando bogum/homúnculo como casos de teste).
- [x] 2 regras pequenas descobertas junto às fichas de Verilêmur/Malafex: "Lágrimas de
      Hyninn" e "Maldição do Caos" → `regras/maldicoes_verilemur_e_malafex.json`.
- Verificação: `bin/build_db` sem erros novos, 421 RSpec + 264 Vitest, 0 falhas, RuboCop
  limpo nos arquivos Ruby tocados.

## Fase C — Montarias ✅ completo
- [x] 25 criaturas em `ameacas/montarias/`: Baleote, Capivara, Cavalo de Carga/Montaria/
      Guerra/Namalkah, Cavalo Glacial, Corcel do Deserto, Dromedário, Elefante, Gorlogg Alfa,
      Leão, Pantera, Tigre, Rinoceronte, Rinoceronte Lanoso, Brontotério, Tatu-Montanha,
      Trobo, Tumarkhân, Urso Panda/Pardo/das Cavernas, Warg, Unicórnio.
- [x] **Colisão de id confirmada e resolvida**: `Gorlogg` já existia no core EJA
      (`ameacas/ermos/gorlogg.json`) com stat block **idêntico** ao reimpresso neste livro —
      enriquecido in-place com o novo campo `parceiro` e `pericias`, sem duplicar id (mesmo
      precedente de "atualizar registro existente" usado para `divindades` em Deuses de
      Arton). `Gorlogg Alfa` (variante ND 5, nova) entra como arquivo novo.
- [x] 4 novos poderes gerais descobertos no sidebar "Novos Poderes de Montarias":
      `poderes_gerais/poderes_de_destino/adestrar_montaria.json` e `dois_como_um.json`,
      `poderes_gerais/poderes_de_combate/combate_montado.json` e `resistencia_montada.json`.
      `Ginete` (pré-requisito de 2 deles) já existia no core.
- [x] `regras/treinando_montarias_selvagens.json`: regra de domar/treinar criaturas
      selvagens como parceiros (bônus "Montarias para Cavaleiros e Paladinos" incluído).
- [x] 2 cavalos (Montaria/Guerra) deliberadamente ficam com `parceiro: null`: o livro não
      redetalha suas estatísticas de parceiro, só diz que reaproveitam as do core (T20 p.262)
      — não fabricado conteúdo que o livro não forneceu.
- Verificação: `bin/build_db` sem erros novos, 421 RSpec + 264 Vitest + `references_spec`
  (0 orphans), 0 falhas.

## Fase D — Novos Perigos ✅ completo
Escopo real bem maior do que estimado inicialmente (~58 entradas mecânicas, não ~12):
- [x] `regras/novos_perigos_ambientais.json`: Ar Saturado, Área Desencantada, Areia Movediça,
      Dejetos Alquímicos, Eletricidade, Lodo Negro, Rio Congelado.
- [x] `regras/armadilhas_ameacas_de_arton.json`: 12 armadilhas novas (Armadilha de Gaiola,
      Runa de Aceleração, Gás Pútrido, Piso Eletrificado, Jato de Chamas, Extrato de Oxxdon,
      Mina Terrestre, Runa de Teletransporte, Símbolo da Anulação, Estátua de Górgona, Runa
      de Desintegração, Sussurro de Sszzaas).
- [x] `regras/doencas_ameacas_de_arton.json`: 12 doenças novas (Alergia Elemental, Doença de
      Descompressão Etérea, Febre do Carniçal, Febre Necrótica, Gripe do Fluxo, Infecção
      Escarlate, Náusea Antinatural, Podridão da Múmia, Praga Coral, Pulmão em Brasa, Rinite
      Feérica, Tremedeira Desastrada).
- [x] `regras/fenomenos_rubros.json`: tabela 1d8 + 7 fenômenos de áreas de Tormenta (Caos de
      Sangue, Chuva Ácida, Labaredas Infernais, Neblina Venenosa, Pesadelos Reais,
      Temperaturas Implacáveis, Tempestade Elétrica).
- [x] `regras/maldicoes_ameacas_de_arton.json`: regras gerais (ativação/detecção/
      resistência/remoção) + 5 maldições nomeadas (Conhecimento Proibido, Fúria de
      Allihanna, Maldição do Bardo, Mortuária, Toque de Tibar).
- [x] `regras/perigos_complexos_ameacas_de_arton.json`: 10 perigos complexos (Biblioteca em
      Ruínas, Briga de Taverna, Ciclone Arcano, Construção em Colapso, Grama Carnívora,
      Inundação de Esgoto, Labirinto, Naufrágio, Pesquisa, Tempestade de Areia) — id distinto
      de `regras/perigos_complexos.json` (Deuses de Arton), que tem 3 perigos totalmente
      diferentes (Vento Abrasador, Pântano Amaldiçoado, Cataclismo); confirmado sem overlap.
- Verificação: `bin/build_db` sem erros novos, 421 RSpec + 264 Vitest, 0 falhas.

## Fase E — Bestiário por facção (~250 criaturas + 29 raças jogáveis)
- [x] **Áreas de Tormenta** — 13 criaturas em `ameacas/areas_de_tormenta/`: Alma Acorrentada
      (ND7), Bruxo da Tormenta (ND6) + Arquibruxo da Tormenta (ND14), Enxame Infernal (ND8),
      Esmagador Coletivo (ND15), Infecto (ND3) + Turba de Infectos (ND7), Lefeu Veridak
      (ND8)/Hurobakk (ND9)/Burodron (ND11)/Morgadrel (ND13)/Ezzayn (ND17, com variantes
      "especiais" Batalhão Burodron/Cavalaria Hurobakk/Esquadrão Veridak documentadas no
      próprio registro), Gatzvalith Lorde da Tormenta (ND "S+" do livro, armazenado como 22
      por convenção editorial — ver nota na própria description).
  - [x] **ND corrigido via Apêndice C (Criaturas por ND) do livro**: várias NDs inline
        apareceram deslocadas pela extração em 2 colunas do PDF (ex.: um "ND 8" flutuante
        ficou perto de Enxame Infernal quando pertencia a outra seção, e Esmagador Coletivo
        — que eu inicialmente supus ND 8 — é na verdade **ND 15** confirmado pelo apêndice).
        Todas as 13 NDs desta leva foram cross-checadas contra o apêndice antes de escrever.
  - [x] `regras/habilidades_lekael.json` (traços comuns a todo Lorde da Tormenta) e
        `regras/armadilhas_vivas.json` (regra geral + 3 armadilhas vivas de exemplo).
  - Verificação: `bin/build_db` sem erros novos, 421 RSpec + 264 Vitest, 0 falhas.
- [x] **Brutos & Indomáveis** — 5 raças jogáveis novas (`racas/meio_orc.json`, `orc.json`,
      `tabrachi.json`, `trog_anao.json`, `ogro.json`) + 13 poderes de raça novos
      (`poderes/habilidades_de_raca/{meio_orc,orc,tabrachi,ogro,trog_anao}/*.json`) + 16
      ameaças novas em `ameacas/brutos_e_indomaveis/`: Meio-Orc Bandoleiro/Capanga/Chefe, Orc
      Veterano/Rei/Mutante Superior/Xamã, Sapo Atroz, Tabrachi Soldado/Campeão, Trog
      Caçador/Rei dos Túneis, Trog Anão Bruto/Eremita, Ogro Caçador/Capanga.
  - [x] **3 colisões de id identificadas e resolvidas por reimpressão idêntica (sem
        arquivo novo)**: `orc_combatente`/`orc_chefe`/`orc_mutante` (grupo `masmorras`) e
        `ogro` (grupo `ermos`) e `trog` (grupo `masmorras`) já existem no core EJA com stat
        blocks **idênticos** aos reimpressos neste livro, sem nenhum campo novo (sem
        `parceiro`, sem mudança de regra) — mantidos como estão, sem duplicar.
  - [x] `Trog Anão` modelado como raça completa e independente (não há mecanismo de "raça
        variante" na gem, só `classes_variantes`), reaproveitando por id os poderes
        `mau_cheiro`/`mordida`/`sangue_frio` do trog base e adicionando só `quase_anao`
        (substitui `reptiliano`).
  - Verificação: `bin/build_db` sem erros novos, 422 RSpec + 264 Vitest + `references_spec`
    (0 orphans), 0 falhas, RuboCop limpo.
- [x] **Capangas & Bandoleiros** — 15 ameaças novas em `ameacas/capangas_e_bandoleiros/`:
      Bandido Ligeiro/Selvagem, Capanga, Jagunço, Capanga Minotauro, Chefe de Gangue/
      Quadrilha, Sacerdote/Alto Sacerdote de Hyninn, Devoto de Hyninn Manhoso/Simão/Velhaco,
      Gatuno, Gatuno Mestre, Duplo (doppelganger).
  - [x] **2 reimpressões idênticas confirmadas, sem duplicar**: "Bandido Comum" = `bandido`
        (grupo `ermos`) e "Chefe Bandido" = `chefe_bandido` (grupo `ermos`), ambos já
        existentes no core EJA com stat blocks idênticos.
  - Verificação: `bin/build_db` sem erros novos, 422 RSpec + 264 Vitest, 0 falhas.
- [x] **Culto de Aharadak** — 10 ameaças novas em `ameacas/culto_de_aharadak/`: Iniciado da
      Agonia, Sacerdote da Agonia, Aspecto de Aharadak, Fanático Lefou, Líder Fanático Lefou,
      Reishid Líder de Culto, Senhor do Gigante Rubro (Forma Inicial/Final), Zyrrinaz, Avatar
      de Aharadak (Culto). Mais `itens_magicos/armas_especificas/adaga_da_tormenta.json`
      (arma específica referenciada por vários lefeu como tesouro), item alquímico
      `semente_rubra.json`, 5 acessórios mágicos "Dádivas de Aharadak" (Armadura/Asas/
      Flagelo/Mente/Olhos do Devorador — simbiontes), e `regras/
      templos_e_dadivas_de_aharadak.json` (perigo de entrar em templos + regra geral de
      simbiontes + Dolorosa Separação + fato "lefeu não têm alma").
  - [x] **Colisão de id real, resolvida por rename**: `Avatar de Aharadak` deste capítulo é
        um stat block **diferente** (ND/PV/habilidades distintos) do `avatar_de_aharadak` já
        existente em `ameacas/avatares/` (grupo da Deuses de Arton) — os dois livros publicam
        fichas diferentes para o mesmo avatar. Resolvido como `avatar_de_aharadak_culto`, sem
        sobrescrever o original; nota cruzada deixada na description de ambos.
  - [x] **2ª colisão descoberta, oposta**: `Reishid` (base, ND8) já existia **idêntico** em
        `ameacas/tormenta/reishid.json` (core EJA) — só `Reishid Líder de Culto` (ND12) era
        novo. O arquivo duplicado foi detectado porque `INSERT OR REPLACE` mascarou a
        colisão silenciosamente (contagem de `ameacas` não mudou no rebuild); descoberto só
        ao conferir `SELECT id FROM ameacas WHERE grupo='culto_de_aharadak'` e notar o id
        faltante. Arquivo duplicado removido.
  - [x] "S e S+" ganhou seu 2º exemplo real (`avatar_de_aharadak_culto`, livro diz "S" →
        armazenado como `nd: 21`), confirmando a convenção aberta em Gatzvalith (Fase E,
        Áreas de Tormenta: S=21, S+=22).
  - Verificação: `bin/build_db` sem erros novos, 422 RSpec + 264 Vitest + `references_spec`
    (0 orphans), 0 falhas.
- [x] **Dragões** — 12 ameaças novas em `ameacas/dragoes/` (sem colisão: todas com nomes
      específicos distintos dos dragões "genéricos" de fogo do EJA core): Dragão Filhote do
      Bosque (ácido)/dos Rios (eletricidade), Ninhada de Dragões Filhotes (fogo, bando),
      Dragão Jovem da Proteção (eletricidade)/do Ocaso (frio), Dragão Adulto da Tirania
      (luz)/dos Segredos (trevas), Dragão Venerável da Equidade (luz)/dos Recifes
      (eletricidade), Dragão Feral (frio), Dragão Bicéfalo (ácido+eletricidade), Sckhar
      Dragão-Rei do Fogo (ND "S+" do livro → `nd: 22`, 3º exemplo real da convenção S/S+).
      Mais `regras/dragoes_energia_e_modificacao.json` (Tabela 1-2: Energia Dracônica +
      regras de familiar/parceiro dracônico + formatos de sopro + como modificar dragões) e
      o poder geral `coracao_de_dragao.json` (Destino).
  - Verificação: `bin/build_db` sem erros novos, 422 RSpec + 264 Vitest + `references_spec`
    (0 orphans), 0 falhas.
- [x] **Duyshidakk** — 2 raças jogáveis novas (`racas/bugbear.json`, `hobgoblin.json`) + 6
      poderes de raça + 12 ameaças novas em `ameacas/duyshidakk/` (mesmo diretório dos
      arauto_de_thwor*/devorador_de_medos*/etc. já existentes do core EJA, sem colisão):
      Bugbear Sentinela/Guarda-Costas, Bruxa Goblin, Gangue Goblin, Horda Goblin,
      Goblin-Bomba, Goblin de Ferro, Goblin de Ferro Mark II, Hobgoblin Atirador/Comandante
      Tático/Gladiador, Sangue do Ayrrak.
  - [x] **Colisão de id real, resolvida por rename**: a habilidade racial `Empunhadura
        Poderosa` do Bugbear tem o mesmo nome/conceito de um poder geral de combate já
        existente no core EJA (`poderes_gerais/poderes_de_combate/empunhadura_poderosa.json`).
        Renomeada para `empunhadura_poderosa_de_bugbear`.
  - [x] **Bug sistêmico descoberto e corrigido nesta leva**: os 19 arquivos
        `habilidades_de_raca/*/*.json` escritos desde a Fase "Brutos & Indomáveis" (13
        arquivos: meio_orc, orc, tabrachi, ogro, trog_anao) até aqui (6 novos: bugbear,
        hobgoblin) **nunca tinham o campo `"livro"`**, fazendo o seeder atribuí-los
        silenciosamente a `t20_eja` em vez de `ameacas_de_arton` (`data["livro"] ||
        "t20_eja"` em `bin/build_db`). Só foi detectado agora porque a colisão do
        Empunhadura Poderosa quebrou um teste de tipo (`raca_spec.rb`) que por acaso also
        expôs o problema. Todos os 19 arquivos corrigidos com `"livro": "ameacas_de_arton"`
        nesta mesma leva (script Python; primeira tentativa corrompeu objetos `effects` em
        arrays de pares, corrigido e revalidado antes do rebuild).
  - Verificação: `bin/build_db` sem erros novos, 422 RSpec + 264 Vitest + `references_spec`
    (0 orphans), 0 falhas.
- [x] **Elementais** — 14 ameaças novas em `ameacas/elementais/`, sem colisão (nomes
      próprios únicos): Água (Aquin'ne, Corgann, Namasqall), Ar (T'Peel, Rarvnaak,
      Hallus'tir), Fogo (Pakk, Ber-baram, Serpentaar), Terra (Terrier, Pamgra, Bando de
      Pamgras, Tanaloom), e Elemental Corrompido (antigo protetor do Rio Panteão
      distorcido pela Tormenta, "Coração de Rubi").
  - Verificação: `bin/build_db` sem erros novos, 422 RSpec + 264 Vitest + `references_spec`
    (0 orphans), 0 falhas.
- [x] **Ermos** — 1 raça jogável nova (`racas/centauro.json`) + 4 poderes de raça + 14
      ameaças novas em `ameacas/ermos/` (mesmo diretório do core EJA, sem colisão): Bulette,
      Carrasco de Lena, Centauro Chefe/Xamã de Megalokk (distintos de
      `centauro_combatente`/`centauro_xama` do EJA, que continuam intactos), Ente, Estirge +
      Enxame Estirge + Nuvem de Estirges, Fera-Vassalo/Líder/Mãe, Lagarto Perseguidor,
      Tendrículo, Rhandomm (ND20, titã de Nimb).
  - [x] `medo_de_altura` já existia como habilidade do Minotauro — renomeado para
        `medo_de_altura_centauro` preventivamente (mesmo padrão do `empunhadura_poderosa`
        da Fase Duyshidakk).
  - Verificação: `bin/build_db` sem erros novos, 422 RSpec + 264 Vitest + `references_spec`
    (0 orphans), 0 falhas.
- [x] **Gnolls** — 1 raça jogável nova (`racas/gnoll.json`) + 4 poderes de raça
      (`poderes/habilidades_de_raca/gnoll/`) + 11 ameaças novas em `ameacas/ermos/` (mesmo
      diretório do core EJA, sem colisão): Gnoll Caçador de Cabeças, Gnoll Capanga, Gnoll
      Líder de Alcateia, Gnoll Xamã de Allihanna/Megalokk/Marah, Hiena, Hiena Rainha,
      Hienodonte, Matrona Gnoll, Gnoll Vuul'rak (ND16, titã deformado ligado à queda de
      Glórienn). `gnoll_saqueador` e `gnoll_filibusteiro` já existiam como reprints do core
      EJA — confirmados idênticos, não duplicados.
  - [x] `faro` já existia como habilidade do Minotauro e `mordida` como habilidade do Trog —
        ambos renomeados preventivamente para `faro_de_gnoll` e `mordida_de_gnoll` (mesmo
        padrão do `empunhadura_poderosa`/`medo_de_altura` nas fases anteriores).
  - [x] Capturado o hazard "Totens Risonhos" (sidebar do Gnoll Líder de Alcateia) como
        `regras/totens_risonhos.json`.
  - Verificação: `bin/build_db` sem erros novos (ameacas: 310, racas: 32, regras: 72), 422
    RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Golens** — 10 ameaças novas em `ameacas/golens/` (novo diretório): Gárgula Assassina,
      Golem de Barro, Golem de Bronze, Golem de Carne, Golem de Espelhos, Golem de Ferro
      Superior, Golem de Matéria Vermelha (lefeu ND18), Golem de Pedra, Instrumento Divino,
      Soldado Mecânico. `gargula` (ND2) e `golem_de_ferro` (ND10) já existiam em
      `ameacas/masmorras/` como reprints idênticos do core EJA — confirmados, não duplicados.
  - [x] Capturada a expansão de criação de personagem "Golens Despertos" (chassis de Barro/
        Bronze/Carne/Espelhos/Ferro/Gelo Eterno/Pedra/Sucata + fontes de energia Alquímica/
        Elemental/Sagrada/Vapor) como `regras/golens_despertos.json`, referenciando o combo
        padrão (Ferro + Elemental + Médio) já representado pela raça `racas/golem.json` do
        core. Decisão: não modificar `golem.json`/`chassi.json`/`fonte_elemental.json`
        existentes (reestruturar `attribute_bonuses` para ser chassi-dependente é uma mudança
        maior, fora do escopo desta passada por bestiário — mesmo tratamento dado ao "Manual
        de Criação de Ameaças" na Fase A, como referência textual/estruturada).
  - Verificação: `bin/build_db` sem erros novos (ameacas: 320, regras: 73), 422 RSpec + 264
    Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Igreja de Arsenal** — 7 ameaças novas em `ameacas/igreja_de_arsenal/` (novo
      diretório): Coletor de Arsenal (ND10), Forjador Litúrgico (ND9), Concílio Forjador
      (ND13, representa um Bando de forjadores), Guerreiro Perpétuo (ND7, morto-vivo
      incorpóreo), Kishin (ND13, golem aspecto de Arsenal), Bispo de Guerra (ND8),
      Kishinauros (ND "S" → armazenado como 21, titã colossal avatar/engenho de guerra de
      Arsenal). `capelao_de_guerra` (ND4) já existia como reprint idêntico do core EJA em
      `ameacas/puristas/` — confirmado (pequena divergência de extração em "Soco de Arsenal"
      5d6+4 vs. 5d6+5, provável erro de OCR, arquivo existente não alterado), não duplicado.
  - Verificação: `bin/build_db` sem erros novos (ameacas: 327), 422 RSpec + 264 Vitest +
    `references_spec` (0 orphans), 0 falhas.
- [x] **Igreja de Kallyadranoch** — 1 raça jogável nova (`racas/kallyanach.json`, meio-dragões
      com escolha de 2 bênçãos dracônicas entre 6) + 9 poderes de raça
      (`poderes/habilidades_de_raca/kallyanach/`) + 10 ameaças novas em
      `ameacas/igreja_de_kallyadranoch/` (novo diretório): Cavaleiro de Kallyadranoch (ND8),
      Corcel de Kally (ND2, montaria), Acólito/Clérigo/Alto Clérigo de Kally (ND3/8/13),
      Dracomante/Dracomante Superior (ND5/14), Kallyanach Bárbaro (ND6), Kallyanach Morte
      Glacial (ND9), Avatar de Kallyadranoch (ND "S" → 21, dragão colossal).
  - [x] Avatar de Kallyadranoch desta seção tem stat block **distinto** do já existente
        `avatar_de_kallyadranoch` (ND20, livro deuses_de_arton, grupo avatares) — mesmo padrão
        do `avatar_de_aharadak`/`avatar_de_aharadak_culto`. Criado `avatar_de_kallyadranoch_dragao.json`
        com nota de referência cruzada em ambos os arquivos.
  - [x] Correção durante a extração: colunas do PDF inicialmente trocaram atributos/perícias/
        equipamento entre Clérigo de Kally (ND8) e Alto Clérigo de Kally (ND13) — corrigido
        antes da verificação final, usando reextração em modo padrão (não layout) para
        confirmar a ordem de leitura correta.
  - Verificação: `bin/build_db` sem erros novos (racas: 33, poderes: 1698, ameacas: 337), 422
    RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Império de Jade** — 4 raças jogáveis novas (`racas/kaijin.json`, `kappa.json`,
      `nezumi.json`, `tengu.json`) + 14 poderes de raça
      (`poderes/habilidades_de_raca/{kaijin,kappa,nezumi,tengu}/`) + 20 ameaças novas em
      `ameacas/imperio_de_jade/` (novo diretório): família Kabuto (Chibi/Ko/Horda de Ko/Dai-
      Kabuto, ND0.25–4), Kaijin Capanga/Bruto/Ninja (ND6/11/13), Kappa Brigão/Yokozuna
      (ND1/3), Mashin Monge/Samurai (ND3/5, construtos golem), Nezumi Capanga/Brutamontes
      (ND1/4), Oni/Aka Oni (ND5/9), Tengu Bandoleiro/Daitengu (ND6/8), Dragão Celestial
      Jovem/Adulto/Venerável (ND10/15/20).
  - [x] Mashin **não** é uma raça jogável própria — o livro descreve explicitamente como
        "um tipo de chassi para personagens golens" (p.160). Adicionado como novo chassi
        "Mashin" em `regras/golens_despertos.json` (com as 10 "maravilhas mecânicas"),
        em vez de criar `racas/mashin.json`.
  - [x] `cria_da_tormenta` (habilidade de raça do Kaijin) é **idêntica** à habilidade já
        existente do Lefou — reutilizado o id diretamente (mesmo padrão de linhagem
        compartilhada do `trog`/`trog_anao`), sem renomear.
  - [x] `empunhadura_poderosa` (Nezumi) colidia com o poder geral de combate já existente —
        renomeado para `empunhadura_poderosa_de_nezumi` (mesmo padrão das fases anteriores).
        `roedor` (Nezumi) e demais ids verificados sem colisão antes de escrever.
  - Verificação: `bin/build_db` sem erros novos (racas: 37, poderes: 1712, ameacas: 357), 422
    RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Império de Tauron** — 1 raça jogável nova (`racas/minauro.json`, meio-minotauro) + 3
      poderes de raça novos (`poderes/habilidades_de_raca/minauro/`) + 12 ameaças novas em
      `ameacas/imperio_de_tauron/` (novo diretório): Arqueiro Escravo (ND5), Centurião/
      Centurião de Elite (ND3/7), Fúria de Tauron/Estouro de Fúrias de Tauron (ND4/5, mortos-
      vivos incorpóreos), Gladiador Táurico (ND8), Legionário/Decúria/Legionário Insano
      (ND1/5/8), Minauro Arcanista/Ladino (ND3/6), Governador Corrupto (ND6).
  - [x] `faro` (Minauro) é **idêntico** à habilidade já existente do Minotauro — reutilizado
        diretamente o id (linhagem compartilhada mãe/pai, mesmo padrão do `trog`/`trog_anao`),
        sem renomear.
  - [x] Encontrado bug de teste: `gladiador_taurico.json` tinha um ataque de Rede com
        `"dano": []` (sem dano, apenas enreda) — `ameaca_spec.rb` exige que `dano` seja `null`
        ou um array não vazio quando presente. Corrigido para `"dano": null`.
  - Verificação: `bin/build_db` sem erros novos (racas: 38, poderes: 1715, ameacas: 369), 422
    RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Kobolds** — 1 raça jogável nova (`racas/kobold.json`, escolha de 2 "Talentos do Bando"
      entre 10) + 13 poderes de raça (`poderes/habilidades_de_raca/kobold/`) + 9 ameaças
      novas em `ameacas/kobolds/` (novo diretório): Cão de Kally (ND2, parceiro fortão),
      Enxame Larval (ND1), Kobold Patrulheiro/Veterano (ND0.5/2), Patrulha Kobold (ND4,
      Bando), Kobold Bruto (ND4), Kobold Explosivo (ND1), Kobold Xamã (ND3), Kobold-Mãe
      (ND12). Capturadas 7 novas armadilhas temáticas em `regras/armadilhas_kobolds.json`
      (Andrajos Flamejantes, Sinos Alarmantes, Geringonça Retardante, Barril de Bugulentos,
      Besunte Galinificador, Tronco de Árvore, Virote Ardido) e a regra de parceiro especial
      "Quem Não Tem Cão Caça com Kobold" (adicionada ao `kobold_patrulheiro.json`).
  - [x] "Vagalhão Kobold" (listado no sumário) acabou sendo apenas um conceito narrativo
        ligado à Kobold-Mãe (origem dos "vagalhões" em Drashantyr), sem stat block próprio —
        não criado como ameaça separada. A micro-regra "Conjurando Kobolds" (aprimoramentos
        de Conjurar Monstro) foi deliberadamente deixada de fora por ser conteúdo muito
        pontual, fora do escopo principal do bestiário.
  - Verificação: `bin/build_db` sem erros novos (racas: 39, poderes: 1728, ameacas: 378,
    regras: 74), 422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Masmorras** — 1 raça jogável nova (`racas/harpia.json`) + 4 poderes de raça
      (`poderes/habilidades_de_raca/harpia/`) + 13 ameaças novas em `ameacas/masmorras/`
      (mesmo diretório do core EJA, sem colisão): Asa-Assassina (ND1), Cocatriz/Cocatriz-Real
      (ND3/7), Harpia Saqueadora (ND4), Glooop/Mamãe Glop (ND2), Mantor (ND5), Mímico (ND6),
      Quimera (ND8, "clássica" Bode/Leão/Dragão com as 10 opções de cabeça documentadas),
      Slark (ND1), Tigre-de-Hyninn/Primordial (ND5/11), Brawar (ND14, construto de adamante).
      `glop` (ND0.25) já existia como reprint idêntico do core EJA — confirmado, não
      duplicado.
  - Verificação: `bin/build_db` sem erros novos (racas: 40, poderes: 1732, ameacas: 391), 422
    RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Mortos-Vivos** — 23 ameaças novas em `ameacas/mortos_vivos/` (novo diretório, sem
      colisões): Carniçal/Lacedon (ND1/2), família Esqueleto (Cavalo ND1, Ogro ND3, Urso Pardo
      ND4, Gigante ND5, Mamute ND8, Hidra ND11, Rei-Tirano ND12), Fantasma/Ancestral (ND7/14),
      família Garra-Zumbi (comum ND0.25, Ogro ND2, Enxame ND3, Gigante ND5), Lívido (ND3),
      Mortalha (ND11), Múmia/Senhor das Múmias (ND5/15), família Necrodraco (Esqueleto ND12,
      Zumbi ND14, Lich ND20, dracolich), Tarso Dragão-Rei dos Mortos (ND "S+" → 22).
      `unicornio` já existia (capturado na Fase C — Montarias); confirmado, não duplicado.
  - Verificação: `bin/build_db` sem erros novos (ameacas: 414), 422 RSpec + 264 Vitest +
    `references_spec` (0 orphans), 0 falhas.
- [x] **Mundo Perdido** — 14 ameaças novas em `ameacas/mundo_perdido/` (novo diretório, sem
      colisões): Árvore-Matilha (ND13), Burafonte/Armento de Burafontes (ND4/8), Deinonico/
      Bando de Deinonicos (ND4/8, com parceiro montaria), Espada-da-Floresta (ND3, construto
      vegetal), Galhada Macho/Fêmea (ND2, parceiros montaria de cura/anti-morto-vivo),
      Gali-Gali/Enxame (ND0.25/1), Grande Battham (ND12), Raagoran (ND8), Tuntram (ND10,
      parceiro montaria), Rei-Tirano (ND14, base da já existente `rei_tirano_esqueleto`).
      Capturados 2 itens alquímicos embutidos nos stat blocks: `fruto_da_espada_mae.json` e
      `figado_de_lagarto_trovao.json` (ritual + consumo para +1 Força permanente).
  - Verificação: `bin/build_db` sem erros novos (itens: 343, ameacas: 428), 422 RSpec + 264
    Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Piratas & Pistoleiros** — 22 ameaças novas em `ameacas/piratas_e_pistoleiros/` (novo
      diretório, sem colisões): Afogado/Capitão Afogado (ND7/10), Armeiro de Tenebra Devoto/
      Clérigo (ND6/8), Demônio da Pólvora (ND12), Goblin/Líder Goblin de Sombreiro (ND2/6),
      Homem-Piranha/Imediato/Capitão (ND2/4/7), Pirata/Imediato/Bando/Capitão/Capitão do
      Conclave (ND0.5/4/6/7/8), Pistoleiro/Líder/Capitão da Frota Áurea (ND2/4/10), Sahuagin
      Predador/Metamorfo (ND1/3), Chapéu-Preto (ND12), Lobo do Mar (ND16). "Habilidades de
      Piratas" (Correr pelo Cordame, Pernas do Mar) repetidas em cada ameaça pirata, mesmo
      padrão de outras habilidades compartilhadas por facção nesta fase.
  - Verificação: `bin/build_db` sem erros novos (ameacas: 450), 422 RSpec + 264 Vitest +
    `references_spec` (0 orphans), 0 falhas.
- [x] **Povos-Trovão** — 4 raças jogáveis novas (`racas/{ceratops,pteros,velocis,voracis}.json`)
      + 14 poderes de raça (`poderes/habilidades_de_raca/{ceratops,pteros,velocis,voracis}/`)
      + 12 ameaças novas em `ameacas/povos_trovao/` (novo diretório): Ceratops Guerreiro/Chefe
      da Tribo (ND3/7), Pteros Ceifador/do Céu Infinito (ND2/5), Velocis Caçador/Xamã de
      Sarana (ND4/6), Voracis Caçadora/Rainha (ND8/11), e os 4 Totens do Trovão — aspectos
      divinos temporários invocados pelos thera: Totem de Sarana (Marah, ND10), Totem da
      Divina Serpente (Allihanna, ND14), Totem do Rei-Tirano (Megalokk, ND15), Totem do
      Pai-de-Tudo (Azgher, ND12).
  - [x] `sentidos_selvagens` (habilidade **idêntica** entre Velocis e Voracis, ambos thera de
        linhagem comum) reutilizado diretamente entre as duas raças, mesmo padrão do
        `trog`/`trog_anao`.
  - [x] `chifres`/`medo_de_altura` (Ceratops) colidiam com as habilidades já existentes do
        Minotauro — renomeados para `chifres_de_ceratops`/`medo_de_altura_ceratops` (chifres
        com dado de dano diferente, 1d8 vs 1d6, confirmando que não era linhagem
        compartilhada). `pes_rapinantes`/`senhor_dos_ceus` (Pteros) colidiam com Harpia e
        com uma distinção de aeronauta goblin — renomeados para `pes_rapinantes_pteros`/
        `senhor_dos_ceus_pteros`.
  - Verificação: `bin/build_db` sem erros novos (racas: 44, poderes: 1746, ameacas: 462), 422
    RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Puristas** — 11 ameaças novas em `ameacas/puristas/` (mesmo diretório do core EJA,
      sem colisão): Arcano de Guerra Adepto/Veterano (ND4/11), Caçador de Impuros (ND8),
      Corcel de Comando (ND3, parceiro montaria) / Carruagem de Comando (ND5), Dançarino de
      Guerra/Veterano (ND4/6), Purificado (ND2, "bomba viva" não humana), Soldado Blindado
      (ND5) / Companhia Blindada de Elite (ND9, Bando), Soldado Superior (ND17).
      "Comandante" (Hermann Von Krauser) é só lore, sem stat block no livro — não criado.
  - Verificação: `bin/build_db` sem erros novos (ameacas: 473), 422 RSpec + 264 Vitest +
    `references_spec` (0 orphans), 0 falhas.
- [x] **Reino dos Mortos** — 10 ameaças novas em `ameacas/reino_dos_mortos/` (novo diretório,
      sem colisões, incluindo `lich` base que não existia no core EJA): Alzeras (ND11),
      Cemitério Vivo (ND17), Chacal-Zumbi (ND2), Mercenário/Líder Mercenário de Aslothia
      (ND3/5), Morgue'raz (ND9), Wisphago (ND8), Lich/Lich de Aslothia (ND15/18), Arquilich
      Ferren Asloth (ND "S" → 21, regente de Aslothia).
  - Verificação: `bin/build_db` sem erros novos (ameacas: 483), 422 RSpec + 264 Vitest +
    `references_spec` (0 orphans), 0 falhas.
- [x] **Reinos de Moreania** — 2 raças novas (`racas/moreau.json`, `racas/yidishan.json`) +
      15 poderes de raça + 8 ameaças novas em `ameacas/reinos_de_moreania/`.
  - Moreau: `chosen_abilities_amount: 1` sobre 12 "Heranças" (coruja, hiena, raposa, serpente,
    búfalo, coelho, crocodilo, gato, leão, lobo, morcego, urso) — cada herança é um arquivo
    único em `poderes/habilidades_de_raca/moreau/` que empacota bônus de atributo + 3
    sub-habilidades nomeadas em um só `effects` (decisão de schema: a escolha é atômica —
    "um bloco completo", não "N habilidades soltas de uma lista" — então 12 arquivos
    combinados em vez de 36 fragmentados).
  - Yidishan: usa `chosen_attribute_bonus: {count:3, value:1, exclude:["carisma"]}`
    diretamente na raça (mesmo padrão de duende/meio-orc/meio-elfo) — corrigido de uma
    tentativa inicial equivocada de criar um arquivo de habilidade separado só pra isso.
  - Ameaças: Búfalo de Guerra (ND2, parceiro montaria), Hippossauro (ND3, parceiro
    montaria), Mantícora Primal (ND14), Horda de Otyughs (ND16, ataques "[Bando]"),
    Yidishan Bugbear (ND2), Raposa Bucaneira (ND2), Búfalo Paladino de Bullton (ND6),
    Coruja Druida (ND10, conjuradora).
  - `manticora` (ND6, grupo masmorras) e `otyugh` (ND5, grupo tormenta) confirmados como
    reimpressões idênticas já existentes no core EJA — não duplicados.
  - Verificação: `bin/build_db` sem erros novos (racas: 46, poderes: 1761, ameacas: 491),
    422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Sanguinárias** — 9 ameaças novas em `ameacas/sanguinarias/` (novo diretório): Cerianthar
      (ND4), Grande Tachygloss (ND16), Oxxdon/Oxxdon Imenso (ND2/10), Razza'Kham (ND17),
      Serpe Anciã (ND8), Uraghian Jovem/Adulto (ND5/8), Kaiju (ND20, usa
      `cura_acelerada: "50/kaiju"` conforme o próprio comentário do schema já previa esse
      formato de exceção; Arsenal Titânico com 9 poderes escolhíveis e Engolir/Titânico
      descritos como poderes especiais de texto).
      `serpe` base (ND5) confirmada reimpressão idêntica já existente no core EJA (grupo
      `ermos`) — não duplicada. O quadro "também encontrados aqui" no fim do capítulo
      (Árvore-Matilha, Basilisco, Burafonte, Dragões, Gali-Gali, Orc, Quimera, Rei-Tirano,
      Trog, Tuntram etc.) é só cross-reference para criaturas já cobertas em outros
      grupos/capítulos — não gera arquivo novo.
  - Verificação: `bin/build_db` sem erros novos (ameacas: 500), 422 RSpec + 264 Vitest +
    `references_spec` (0 orphans), 0 falhas.
- [x] **Sob as Ondas** — 1 raça nova (`racas/elfo_do_mar.json`, jogável) + 3 poderes de raça
      (`arsenal_do_oceano`, `cria_das_aguas`, `dependencia_de_agua` — sem sufixo, deixados
      genéricos para reuso futuro por Sereia/Tritão caso venham a precisar da mesma mecânica)
      + 20 ameaças novas em `ameacas/sob_as_ondas/` (novo diretório): Canceronte/Canceronte
      de Guerra (ND3/16), Elfo-do-Mar Pescador/Chefe/Druida (ND2/6/10, versões NPC da raça),
      Enguia Rainha (ND19), Irukanjin (ND4), Água-viva/Enxame de Águas-vivas/Água-viva
      Gigante (ND1/6/8), Nereida (ND12), Peixe-Recife (ND6), Platan (ND2, parceiro montaria),
      Selako/Selako-Tigre/Cardume de Selakos (bando)/Mega-Selako (ND2/6/9/12, Selako também
      parceiro montaria), Pliorex/Pliorex Abissal (ND5/10), Kraken (ND19).
      Nenhuma colisão de id encontrada neste grupo. "Redução de impacto/ácido N" (tipo-
      específica, não RD genérica) corretamente modelada em `resistencias` em vez de
      `reducao_de_dano`, conforme convenção já documentada. "Enxame" (água-viva) e "Ataque
      Sônico" (platan) corrigidos de `ataques` para `poderes_especiais` por não terem teste
      de ataque — mesmo padrão de breath weapons dos dragões.
  - Verificação: `bin/build_db` sem erros novos (racas: 47, poderes: 1764, ameacas: 520),
    422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Sszzaazitas** — 1 raça nova (`racas/nagah.json`, jogável) + 5 poderes de raça
      (`ajuste_de_atributo_nagah` modela o bônus condicionado ao sexo — For+1/Des+1/Con+1
      macho vs Int+1/Sab+1/Car+1 fêmea — via um `effects.attribute_bonus_by_sex` dedicado,
      já que não existe schema para bônus de atributo condicional ao sexo; `cauda_nagah`,
      `inocencia_dissimulada`, `presentes_de_sszzaas`, `fraquezas_ofidicas`) + 17 ameaças
      novas em `ameacas/sszzaazitas/` (diretório já existente do core EJA): Iniciada de
      Sszzaas (ND3), Elemental do Veneno Pequeno/Médio/Grande (ND2/8/12), Górgona/Górgona
      Matriarca (ND6/14), Nagah Encantadora (ND7), Nagah Dormente (ND3) + Hynne Dormente
      (ND5, exemplo nomeado de dormente disfarçado), Nagah Defensor (ND7), Nagah Retalhador
      (ND12), Nagah Sacerdotisa (ND5), Rival Espelho (ND variável — usa `nd:0` como
      placeholder NOT NULL, todos os campos numéricos documentados como placeholder;
      ND real = a do personagem copiado), Zumbi Peçonha (ND1), Nastarrath (ND18),
      Sszzaazita Celebrante (ND16).
  - **Duas colisões de id com o core EJA já existente na pasta**: `cultista_de_sszzaas`
      (ND7) confirmado reimpressão idêntica — não duplicado. `nagah_mistica` (ND6) tinha
      estatísticas DIFERENTES (versão simplificada do EJA, sem `livro` definido, CD/perícias/
      atributos distintos) — mantido o arquivo original intacto e criada a versão do livro
      como `nagah_mistica_de_arton`, com cross-reference nas descrições de ambos os arquivos.
      `nagah_guardiao` (ND3, já existente) não colide — nome distinto do livro ("Nagah
      Defensor"), mantido como está.
  - **Falha de teste corrigida**: `rival_espelho.json` com `"salvaguardas": {}` (sem chaves
      fort/ref/von) quebrou `ameaca_spec.rb` (`have_key("fort")`); corrigido para
      `{"fort":null,"ref":null,"von":null}` como placeholder explícito.
  - Verificação: `bin/build_db` sem erros novos (racas: 48, poderes: 1769, ameacas: 537),
    422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Trolls Nobres** — 1 raça nova (`racas/finntroll.json`, jogável — PJs finntroll sempre
      rejeitam o Império Trollkyrka) + 4 poderes de raça (`corpo_vegetal_finntroll`,
      `presenca_arcana_finntroll`, `regeneracao_vegetal_finntroll`, `intolerancia_a_luz_finntroll`)
      + 11 ameaças novas em `ameacas/trolls_nobres/` (diretório já existente do core EJA):
      Arcanista Finntroll (ND14), Defeituoso (ND6), Mycotann Labutador/Druida (ND2/5) +
      Horda Mycotann (ND12, Bando), Finntroll Senhor de Estábulo (ND12), Perdigueiro Troll
      (ND1, parceiro perseguidor), Protetor-Refém (ND5, anão escravizado), Cavaleiro Finntroll
      (ND7, parceiro montaria troll), Sacerdote Finntroll (ND6) / Alto Sacerdote Finntroll
      (ND12).
  - **Duas colisões de id confirmadas como reimpressões idênticas do core EJA**:
      `finntroll_cacador` (ND2) e `finntroll_feitor` (ND6) já existentes com stats
      coincidentes — não duplicados. `troll` (base) também já existente — apenas
      referenciado por "Abrir os Viveiros"/"Corcel Troll", não reprint.
  - **Bug de schema descoberto e corrigido nos arquivos novos**: `resistencia_a_veneno` e
      `resistencia_a_efeitos_mentais` NÃO são colunas reais da tabela `ameacas` (só existe
      `resistencia_a_magia` como coluna dedicada) — `bin/build_db` ignora silenciosamente
      esses campos. Corrigido nos 9 arquivos novos de Sszzaazitas + `protetor_refem.json`
      para usar o campo livre `resistencias` (ex.: `{"veneno":5}`). Os 3 arquivos
      pré-existentes do core EJA com o mesmo campo morto (`cultista_de_sszzaas.json`,
      `nagah_mistica.json`, `nagah_guardiao.json`) foram deixados intocados — fora do
      escopo desta sessão, mas registrados aqui como dívida técnica para limpeza futura.
  - Verificação: `bin/build_db` sem erros novos (racas: 49, poderes: 1773, ameacas: 548),
    422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Uivantes** — 1 raça nova (`racas/soterrado.json`, variante jogável de `osteon` —
      reaproveita `natureza_esqueletica`/`preco_da_nao_vida` de osteon e substitui
      `armadura_ossea`/`memoria_postuma` por 2 poderes novos: `abraco_gelido`,
      `esquife_de_gelo_soterrado`) + 15 ameaças novas em `ameacas/uivantes/` (novo
      diretório): Carcaju (ND1, parceiro fortão), Golem de Nor Médio/Grande/Enorme
      (ND1/8/10 — raça jogável "Golem de Gelo Eterno" já capturada como chassi em
      `regras/golens_despertos.json` na Fase Golens, não duplicada), Mamute (ND8,
      parceiro montaria = elefante) + Lyuba (ND14, mamute morto-vivo vingativo),
      Minotauro da Manada/Chefe da Manada (ND2/6), Ogro Furioso (ND5) + Keylor (ND9,
      gigante líder nomeado), Soterrado Vagante (ND2, versão selvagem/NPC da raça),
      Stagh (ND3, familiar elemental do gelo), Urso das Neves (ND5, parceiro montaria),
      Verme do Gelo Larva/Adulto (ND10/18).
  - Nenhuma colisão de id encontrada neste grupo.
  - Verificação: `bin/build_db` sem erros novos (racas: 50, poderes: 1775, ameacas: 563),
    422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.
- [x] **Chefe Final / Rei da Arena** — capítulo de regras, não bestiário: capturado como
      `regras/chefe_final.json` (conversão genérica "criando um chefe final" — dobrar PV,
      +2 PM/ND, Maior que a Morte + RD por patamar, +2 ND — mais o arquétipo "Rei da Arena"
      com 9 arenas e 11 recursos, cada um com os 4 valores por patamar iniciante/veterano/
      campeão/lenda) + o exemplo completo de criação do livro capturado como
      `ameacas/exemplos_de_criacao/bispo_do_forte_sagrado.json` (ND10, mesmo padrão já usado
      para Dejeto Vivo/Cardume de Aquin'ne na Fase A).
  - Verificação: `bin/build_db` sem erros novos (regras: 75, ameacas: 564), 422 RSpec + 264
    Vitest + `references_spec` (0 orphans), 0 falhas.

## Fase E — CONCLUÍDA ✅ (todos os 28 grupos do bestiário + 29 raças jogáveis processados)

## Fase F — Capítulo 3: Bazar Monstruoso ✅ completo
- [x] **Armas (16)**: Simples — Porrete, Zarabatana; Marciais — Neko-te, Gládio, Tetsubo;
      Fogo — Traque, Arcabuz, Bacamarte; Exóticas — Açoite Finntroll, Espada Vespa,
      Pistola-Punhal, Mordida do Diabo, Presa de Serpente, Lança de Fogo, Shuriken, Arpão.
      Nova habilidade de arma "Híbrida" adicionada a `regras/habilidades_armas.json`
      (Pistola-Punhal e Lança de Fogo usam `especial.modo_corpo_a_corpo`/`modo_distancia`
      para os dois modos, já que o schema de `armas` só suporta um dano/crítico/alcance por
      linha). Zero colisões de id.
- [x] **Armaduras e Escudos (4)**: Armadura de Ossos, Armadura de Quitina, Veste de Teia de
      Aranha, Escudo de Couro. Zero colisões.
- [x] **Itens Gerais (45)**: Equipamento de Aventura (4: Caixa de Voz, Corda de Teia, Dente
      de Wisphago, Gema de Força), Vestuário (5), Esotéricos (3), Alquímicos — Preparados (9),
      Catalisadores (4), Venenos (4), Alimentação (7), Animais (9 — Bulette, Capivara, Corcel
      do Deserto, Dromedário, Elefante, Hiena, Leão, Rinoceronte, Urso Pardo; são entradas de
      preço em `itens/animais`, distintas das fichas completas de ameaça já existentes nos
      grupos `montarias`/`ermos` — mesmo padrão já usado por `cavalo.json`).
  - **Bug de campo morto confirmado em outro canto do schema**: `resistencia_a_veneno` não é
      lido por `bin/build_db` para a tabela `ameacas` (ver nota em Trolls Nobres); não afeta
      `itens`, que usa o campo livre `effects`.
- [x] **Itens Superiores**: 2 melhorias novas (`multifuncional` em
      `melhorias/ferramentas_vestuario/`, `penetrante` — pré-requisito `cruel` — em
      `melhorias/armas/`) + 8 materiais especiais novos em `materiais_especiais/` (Casco de
      Monstro, Couraça de Kaiju, Couro de Bulette, Cristal de Sol, Lanajuste, Pena de Kraken,
      Prata, Quitina Razza — preço via `precos_adicionais`, mesmo campo (não lido por
      `build_db`, mas mantido por consistência com `mitral.json` e demais materiais
      pré-existentes) usado em todo o restante da tabela de materiais especiais).
  - Variante opcional "Lancinante Revisado" adicionada como `effects[].type: variante_opcional`
      dentro do `lancinante.json` já existente (não um encanto novo — é uma versão alternativa
      do mesmo encanto para campanhas que querem limitar dano de críticos).
- [x] **Recursos Naturais**: capturado como `regras/recursos_naturais.json` — regra geral de
      extração (1h de trabalho + Sobrevivência/Ofício CD 15+ND), Tabela 3-5 (tipo de criatura
      → recurso via 1d6) e Tabela 3-6 (patamar → valor) como dados estruturados, e os 7 tipos
      de recurso (Carapaça, Couro, Fonte, Ingrediente, Mantimento, Osso, Sucata) com suas
      descrições completas.
- [x] **Novos Itens Mágicos (6)**: Chifre de Unicórnio e Fragmento de Filactério (acessórios
      maiores, não fabricáveis) e Pilão Conspurcado (acessório médio) em `itens_magicos/
      acessorios/`; Grilhão de Descrença (armadura específica menor, maldição permanente) em
      `armaduras_especificas/`; Pistola Demoníaca e Uyzrrak Da'Ukthra (armas específicas
      médias) em `armas_especificas/`.
- [x] **Novos Artefatos (2)**: Amuleto do Abutre (filactério secundário de Ferren Asloth,
      maldição progressiva de 3 níveis) e Rompedor da Realidade (machado lefeu anticriatura)
      em `itens_magicos/artefatos/`.
- [x] **Novas Magias (7)**: Açoite Flamejante (Arcana 1), Dardo Gélido (Arcana 1), Invocar
      Fagulha Elemental (Arcana 2), Jato Corrosivo (Arcana 1), Katana Celestial (Divina 5),
      Momento de Tormenta (Universal 2, restrita/proibida fora da Academia Arcana — 11ª
      infração do Vigintílogo), Transformação em Dragão (Arcana 4). Também capturados 4 novos
      aprimoramentos da magia já existente `conjurar_mortos_vivos.json` (Soterrado — apenas
      arcanos; Fúria de Tauron; Guerreiro Perpétuo — apenas devotos de Arsenal; Zumbi Peçonha
      — apenas devotos de Sszzaas), cada um com sua entrada em `statistc_details`.
- Verificação: `bin/build_db` sem erros novos (armas: 96, armaduras: 23, escudos: 6, itens:
  388, melhorias: 48, materiais_especiais: 14, regras: 76, acessorios_magicos: 137,
  armas_magicas_especificas: 38, armaduras_magicas_especificas: 25, artefatos: 32, magias:
  252), 422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas em cada lote.

## Fase G — Apêndice D: Encontros Aleatórios ✅ completo
- [x] Regra geral capturada em `regras/encontros_aleatorios.json`: condições de rolagem
      (Tempo, Barulho, Área Específica, Perigo Complexo), ajuste de patamar (+30/+70/+110),
      a regra do Rhandomm (1d4, resultado "1" substitui o encontro num 100 natural), e o
      mapeamento "Encontros por Região" completo (~35 regiões nomeadas de Arton → terrenos/
      tabelas regionais aplicáveis).
- [x] **11 tabelas de terreno** em `tabelas/encontros_<terreno>.json` (Aquático, Ártico, Área
      de Tormenta, Colina, Deserto, Floresta, Montanha, Pântano, Planície, Subterrâneo,
      Urbano) + **7 tabelas de região** (Aslothia, Estradas do Reinado, Galrasia, Império de
      Tauron, Sanguinárias, Supremacia Purista, Ruínas de Tyrondir/Lamnor) — 18 tabelas no
      total, cada uma com ~27 faixas de rolagem 1d% (até "201+"), usando o campo `dice`/
      `headers`/`rows` já estabelecido pela tabela `tabelas` (mesmo padrão de
      `nomes_anao.json`). Nenhuma ameaça individual foi criada a partir dessas tabelas —
      todas as criaturas citadas já existem no gem (a maioria com `*` indicando reprint do
      Tormenta20 core, mantido como texto livre na célula de encontro).
- Verificação: `bin/build_db` sem erros novos (regras: 77, tabelas: 51), 422 RSpec + 264
  Vitest + `references_spec` (0 orphans), 0 falhas.

# AMEAÇAS DE ARTON — SUPLEMENTO CONCLUÍDO ✅
Todas as 7 fases (A–G) foram processadas: regras avançadas de ameaças, mascotes/familiares,
montarias, novos perigos, bestiário completo por facção (28 grupos + 29 raças jogáveis),
bazar monstruoso (armas/armaduras/itens/materiais/itens mágicos/artefatos/magias) e
encontros aleatórios (11 terrenos + 7 regiões). Ver seção "Fase final" abaixo para o
relatório de decisões editoriais e verificação final.

## Fase final ✅ completo
- [x] **Checklist fechado**: todas as fases A–G marcadas `[x]`, com notas de colisão de id,
      decisões de schema e bugs descobertos registradas em cada seção.
- [x] **Suíte completa**: `bin/build_db` final sem erros (racas: 50, poderes: 1775,
      divindades: 23, classes: 16, magias: 252, armaduras: 23, armas: 96, itens: 388,
      escudos: 6, materiais_especiais: 14, melhorias: 48, encantamentos: 161, regras: 77,
      tabelas: 51, armas_magicas_especificas: 38, armaduras_magicas_especificas: 25,
      artefatos: 32, ameacas: 564) + 422 exemplos RSpec + 264 testes Vitest +
      `references_spec` (4 exemplos, 0 orphans) — 0 falhas.
- [x] **Rubocop**: nenhuma issue nova introduzida por este trabalho (0 arquivos Ruby tocados
      nesta sessão, apenas JSON). A única issue restante (`Lint/ConstantDefinitionInBlock` em
      `spec/ruby/concerns/livro_scoped_spec.rb`) é pré-existente e fora do escopo.
- [x] **Relatório de decisões editoriais** (principais, por categoria):
  - **Esquemas novos introduzidos**: `attribute_bonus_by_sex` (nagah, bônus condicionado ao
    sexo — não existia precedente); `especial.modo_corpo_a_corpo`/`modo_distancia` para armas
    híbridas (pistola-punhal, lança de fogo — schema de `armas` só suporta um dano/crítico/
    alcance por linha); `nd: 0` como placeholder NOT NULL para Rival Espelho (ND variável =
    a do personagem copiado); `cura_acelerada`/`reducao_de_dano` em formato `"N/exceção"`
    usados pela primeira vez em larga escala (kaiju, nastarrath, mortos-vivos).
  - **Bug de schema descoberto e corrigido**: `resistencia_a_veneno` e
    `resistencia_a_efeitos_mentais` não são colunas reais da tabela `ameacas` — apenas
    `resistencia_a_magia` existe como coluna dedicada. `bin/build_db` ignora esses campos
    silenciosamente. Corrigido em todos os arquivos novos desta sessão (campo livre
    `resistencias` usado em seu lugar); 3 arquivos pré-existentes do core EJA com o mesmo
    campo morto (`cultista_de_sszzaas.json`, `nagah_mistica.json`, `nagah_guardiao.json`)
    foram deixados intocados — dívida técnica registrada, fora do escopo de correção
    retroativa nesta sessão.
  - **Colisões de id resolvidas por categoria**:
    - *Reimpressões idênticas do core EJA → não duplicadas*: `glop`, `unicornio`, `serpe`
      (base), `manticora`, `otyugh`, `finntroll_cacador`, `finntroll_feitor`, `troll`,
      `cultista_de_sszzaas`.
    - *Mesmo nome, estatísticas diferentes → sufixo + cross-reference*: `nagah_mistica`
      (EJA, simplificada) vs. `nagah_mistica_de_arton` (Ameaças de Arton, expandida).
    - *Raça variante (não nova raça do zero)*: `soterrado` reaproveita 2 das 4 habilidades
      de `osteon` e substitui as outras 2 (`abraco_gelido`, `esquife_de_gelo_soterrado`).
    - *Golem de Gelo Eterno*: referenciado apenas como chassi já capturado em
      `regras/golens_despertos.json` (Fase Golens) — não recriada uma raça separada.
  - **Conteúdo mecânico vs. bestiário**: "Chefe Final/Rei da Arena" tratado como regra
    (`regras/chefe_final.json`) + exemplo completo
    (`ameacas/exemplos_de_criacao/bispo_do_forte_sagrado.json`), não como bestiário — mesmo
    padrão já usado para o Manual de Criação de Ameaças na Fase A.
  - **Aprimoramentos/variantes de conteúdo pré-existente** (em vez de arquivos novos
    duplicados): "Lancinante Revisado" adicionado como `effects[].type: variante_opcional`
    dentro do `lancinante.json` já existente; 4 novos aprimoramentos de
    `conjurar_mortos_vivos.json` (soterrado/fúria de tauron/guerreiro perpétuo/zumbi
    peçonha) adicionados ao array `enhancements` existente, com `statistc_details`
    correspondentes.
  - **29 raças jogáveis**: todas capturadas ao longo da Fase E, uma por grupo onde
    apareceram no bestiário (bugbear, hobgoblin, centauro, gnoll, harpia, kallyanach,
    kaijin/kappa/tengu/minauro, kobold, ceratops/pteros/velocis/voracis, moreau/yidishan,
    elfo_do_mar, nagah, finntroll, soterrado, meio_orc/orc, dentre outras já cobertas em
    sessões anteriores a esta janela).
