# Tabelas — auditoria de cobertura

Rastreia, para cada tabela nomeada do T20 EJA (`Tabela X-Y: Nome`), se o conteúdo já foi extraído para este diretório (ou para `regras/`), se já está coberto de outra forma, ou se está pendente.

Cada uma foi conferida individualmente contra os dados já normalizados no banco (armas, armaduras, ameaças, itens mágicos etc.) para descartar redundância — o que é listado como "já coberta" é conteúdo genuinamente extraído ou confirmado como duplicado.

## Pendentes

Nenhuma pendência conhecida. Varredura completa do PDF (todos os Capítulos 1–8, 60 tabelas nomeadas `Tabela X-Y`) feita em 2026-09-06 — todas extraídas ou confirmadas redundantes.

## Já cobertas (não redundantes, adicionadas em 2026-07-17)

- `regras/dificuldades.json` — Tabela 5-1 (escada de CD)
- `regras/situacoes_especiais.json` — Tabela 5-3 (modificadores de ataque/Defesa)
- `regras/estatisticas_de_objetos.json` — Tabela 5-4 (Def/RD/PV de objetos; cobre as duas seções: objetos gerais e armas/armaduras/escudos)
- `tabelas/riquezas.json` — Tabela 8-2 (tesouro por raridade)

## Já cobertas (adicionadas em 2026-09-06)

- `tabelas/tesouro_por_nd.json` — Tabela 8-1 (Tesouro por Nível de Desafio; 22 linhas de ND 1/4 a 20, cada uma com subtabelas Dinheiro e Itens, extraídas célula por célula do Cap. 8, p.328-329)
- `tabelas/tesouro_medio_por_cena.json` — Tabela 8-6 (Tesouro Médio por Cena; p.332)
- `regras/custo_de_atributos.json` — Tabela 1-1 (custo em pontos / faixa de rolagem 3d6 por valor de atributo; p.17)
- `regras/testes_estendidos.json` — Tabela 5-2 (sucessos exigidos x complexidade; p.223)
- `regras/estatisticas_de_npcs.json` — Tabela 6-1 (bônus de perícia forte/fraca por patamar; p.259)
- `regras/preco_encantos.json` — Tabela 8-7 (aumento de preço/CD por nº de encantos; p.334)
- `tabelas/estatisticas_npc_por_nd.json` — Tabela 7-2 (ataque/dano/Defesa/PV/perícias/CD por ND, 20 linhas; p.322)
- `tabelas/encantos_armas_magicas.json` — Tabela 8-8 (rolagem d% de encanto de arma mágica, com `encanto_id` referenciando `itens_superiores/encantamentos/armas/`; p.336)
- `tabelas/encantos_armaduras_escudos_magicos.json` — Tabela 8-10 (rolagem d% de encanto de armadura/escudo mágico, com `encanto_id` referenciando `itens_superiores/encantamentos/armaduras_escudos/`; p.339)
- `tabelas/ideias_de_masmorras.json` — Tabela 6-2 (temas de masmorra, d20; p.263)
- `tabelas/portas.json` — Tabela 6-3 (RD/PV/CD para arrombar portas; p.265)
- `tabelas/velocidade_de_viagem.json` — Tabela 6-4 (distância por hora/dia por deslocamento; p.266)
- `tabelas/eventos_de_perseguicoes.json` — Tabela 6-5 (obstáculos/atalhos em perseguições; p.274)
- `tabelas/desafios_de_buscas.json` — Tabela 6-6 (perícia exigida por desafio de busca, 2d12; p.279)
- `tabelas/consequencias_de_buscas.json` — Tabela 6-7 (sucessos → recompensas/castigos de busca, com a subtabela 1d6 de tipos e as definições de cada recompensa/castigo dobradas na `description`; p.278/283)

Também confirmado como **já coberto antes desta rodada** (não estava documentado aqui, mas os arquivos já existiam): Tabela 1-21 (`regras/tamanhos.json`), Tabela 3-1 (`regras/dinheiro_inicial.json`), Tabela 3-2 (`regras/passos_dano.json`), Tabela 4-1 (`regras/conjuracao.json`, campo `custos_por_circulo`).

## Confirmadas como redundantes (não precisam de tabela própria)

- **Tabela 7-1: Criaturas por Nível de Desafio** — é só um índice cruzado de criaturas por ND; já coberto por `Ameaca.byNd(nd)` / `upToNd(nd)` sobre a tabela `ameacas`.
- **Tabelas 1-2, 1-3, 1-19, 1-20 (índices de raças/classes/origens/deuses)** — apenas resumos; os dados completos já estão em `racas/`, `classes/`, `origens/`, `divindades/`.
- **Tabelas 1-5 a 1-18 (progressão de cada classe)** — já embutidas em `classes/*.json` no campo `progression`.
- **Tabelas 3-3 a 3-9 (armas, armaduras, itens, melhorias, materiais)** — já normalizadas em `equipamentos/`, `itens_superiores/`.
- **Tabelas 8-9, 8-11 (armas/armaduras específicas)** — já normalizadas em `itens_magicos/armas_especificas/` (18 registros) e `itens_magicos/armaduras_especificas/` (13 registros); contagens batem exatamente com as linhas das tabelas do livro.
- **Tabelas 8-3, 8-4, 8-5 (itens diversos, equipamento, itens superiores)** — rolagens sobre dados já normalizados em `equipamentos/` e `itens_superiores/`.
- **Tabelas 8-12 a 8-15 (poções, acessórios menor/médio/maior)** — já normalizadas em `itens_magicos/pocoes/` e `itens_magicos/acessorios/`.

  Correção: a nota anterior deste README dizia "Tabelas 8-7 a 8-15 já normalizadas" — isso estava impreciso. 8-7 (preço de encantos) e 8-8/8-10 (rolagem de tipo de encanto) eram tabelas de regra/geração aleatória distintas, não preços de item, e estavam genuinamente faltando (agora cobertas acima).

## Aviso

Varredura completa feita em 2026-09-06 cobrindo todos os Capítulos 1–8 (60 ocorrências de `Tabela X-Y` no PDF, todas conferidas). Processo usado: `grep -noE "^Tabela [0-9]+-[0-9]+.*" texto_extraido.txt`, cruzando cada nome contra `regras/`, `tabelas/` e as tabelas normalizadas (`classes/`, `racas/`, `equipamentos/`, `itens_superiores/`, `itens_magicos/`, `ameacas/`). Se o livro ganhar uma nova edição/errata, repetir o mesmo processo.
