# Checklist — Atlas de Arton (4º e último suplemento planejado)

Fonte: `/home/luan/arkheion/recursos/Atlas-de-Arton-v1.0-17-11-2023.pdf` (484 páginas).

## Escopo

Decisão de escopo já registrada na memória do projeto (2026-07-17): lore/detalhes do mundo
de Arton ficam FORA da gem — só conteúdo mecânico (crunch). O Atlas é majoritariamente lore
(Capítulos 1-5: história, regiões, organizações, sociedade) — tudo isso fica de fora.

**Único conteúdo mecânico do livro**: Apêndice "Origens Regionais" (p.471-480 do PDF, array
index 471-480), confirmado via outline do PDF — não há mais nada de crunch no restante do
livro (verificado contra o sumário completo).

## Origens Regionais ✅ completo

- [x] **66 origens regionais** capturadas em `origens/*.json` + seus poderes correspondentes
      (`poderes/habilidades_unicas_de_origem/*.json`, `type: habilidade_unica_origem`), mesmo
      padrão já usado pelas origens comuns do EJA/Heróis de Arton (ex.: `mensageiro.json` +
      `mensageiro_incansavel.json`).
  - **Decisão de schema**: diferente das origens comuns, origens regionais não têm um nome
    de habilidade próprio e distinto do nome da origem (o livro usa só "Benefício." em texto
    corrido). Decisão: usar o mesmo id para a origem e seu poder (`anao_de_armas` /
    `anao_de_armas`), já que `origens` e `poderes` são tabelas independentes sem risco de
    colisão de chave entre si. Evita inventar ~66 nomes artificiais de habilidade que o
    livro não fornece.
  - **Região sem campo dedicado no schema**: a tabela `origens` não tem coluna para região
    (só `id, name, description, items, benefits, unique_power`). Decisão: a região é
    embutida no início da `description` ("Origem regional de Doherimm. ...") para
    permanecer pesquisável, já que qualquer chave JSON extra fora da lista lida por
    `seed_origens` em `bin/build_db` é descartada silenciosamente (mesmo comportamento já
    visto em outras tabelas nesta expansão).
  - **Duas origens multi-região**: Amazona de Hippion (Deheon + Namalkah) e os pares que
    compartilham a mesma origem entre regiões diferentes na Tabela: Origens Regionais do
    livro — descrição lista as duas regiões, um único arquivo (sem duplicação).
  - **Origem "Legionário"**: cross-referencia explicitamente `gládio`, item já adicionado à
    gem no suplemento Ameaças de Arton (proficiência com gládios) — dependência entre
    suplementos confirmada e preservada na descrição.
  - **"Por um Punhado de Tibares"** (regra de risco da origem Procurado: Vivo ou Morto —
    1x por aventura, encontro com caçadores de recompensa de ND igual ou inferior ao
    grupo) e **"Tatuagem Mística"** (regra dos tatuadores tamalus referenciada pela origem
    Tamalu) e **"Alikunhá"** (parceiro elemental dos ubaneri, referenciado por Andarilho
    Ubaneri e Emissário Ubaneri) e **"Encontrando-se Consigo Mesmo"** (regra do confronto
    entre um duplo e sua versão original, referenciada pela origem Duplo Feérico) — todos
    esses quadros de regra lateral foram **incorporados diretamente na descrição do poder
    correspondente** em vez de criar regras separadas, já que cada um só é relevante para
    exatamente uma origem (não há reuso cruzado que justifique um arquivo `regras/*.json`
    próprio, ao contrário de callouts compartilhados vistos em Ameaças de Arton).
  - Nenhuma colisão de id com conteúdo pré-existente (EJA/Heróis/Deuses/Ameaças).
  - Livro registrado: `src/json/livros/atlas_de_arton.json` (`atlas_de_arton`).
- Verificação: `bin/build_db` sem erros novos (origens: 131 [+66], poderes: 1841 [+66],
  livros: 5 [+1]), 422 RSpec + 264 Vitest + `references_spec` (0 orphans), 0 falhas.

## Fora do escopo (lore, confirmado)
Capítulo 1: O Reinado (Deheon, Valkaria, Bielefeld, Namalkah, Wynlla, Ahlen, Zakharov,
Pondsmânia, Academia Arcana, Vectora). Capítulo 2: Além do Reinado (17 regiões). Capítulo 3:
Além de Arton (11 regiões). Capítulo 4: Organizações (Exércitos & Mercenários, Igrejas &
Ordens, Guildas & Irmandades). Capítulo 5: Vida em Arton (sociedade, viagens, comércio,
arte/cultura, lei, vida de aventureiro). Introdução/História de Arton/Linha do Tempo.
Nenhum desses capítulos contém crunch extraível — são descrições de lugares, organizações e
costumes, sem tabelas numéricas, poderes ou itens mecânicos novos.

# ATLAS DE ARTON — SUPLEMENTO CONCLUÍDO ✅

Com isso, **todos os 4 suplementos planejados para a expansão da gem `tormenta20` estão
completos**: Heróis de Arton, Deuses de Arton, Ameaças de Arton e Atlas de Arton.
