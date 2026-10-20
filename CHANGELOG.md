## [Unreleased]

### Adicionado

- Suporte a vários livros: tabela `livros`, coluna `livro_id` em todos os registros, scope `do_livro` e associação `livro` em todos os modelos Ruby, `livroId` nos modelos TypeScript.
- Conteúdo de **Heróis de Arton**: raças, Treinador, classes variantes, origens, distinções, complicações, poderes de raça e de grupo, equipamentos, encantamentos, esotéricos, itens mágicos, tipos de base, cômodos, mobílias e construções de domínio.
- Conteúdo de **Deuses de Arton**: deuses menores, Frade, poderes concedidos, distinções, itens litúrgicos, artefatos e magias.
- Conteúdo de **Ameaças de Arton**: bestiário por grupo, raças jogáveis, montarias, mascotes e familiares, equipamentos, materiais especiais, regras de ameaças e tabelas de encontros aleatórios.
- Conteúdo do **Atlas de Arton**: 66 origens regionais.
- Bestiário do livro básico e modelos novos: `Ameaca`, `ClasseVariante`, `Distincao`, `Complicacao`, `BaseTipo`, `Comodo`, `Mobilia`, `ConstrucaoDominio`, `EsotericoMagico`, `ArmaMagicaEspecifica`, `ArmaduraMagicaEspecifica`, `ItemLiturgico`, `Artefato`, `Tabela#dice`/`roll`.
- Ruby: `Tormenta20.classes_variantes`; scopes `Poder.by_class`, `habilidades_de_raca`, `poderes_combate`, `poderes_destino`, `poderes_magia`, `poderes_de_raca`, `poderes_de_grupo`; `Ameaca.up_to_nd`.
- TypeScript: `ClasseVariante` exportado; tipos `ConstrucaoDominioCategoria` e `ItemLiturgicoSubtipo` exportados.
- Documentação de todos os 34 modelos em `docs/ruby` e `docs/ts`.

### Corrigido

- Seeder TypeScript equivalente ao `bin/build_db`: colunas com chave errada (`efeito`, `penalidade`, `category`, `habilidades`), `livro_id` ausente, tabelas que não eram populadas e valores JSON que eram gravados como texto cru (`cura_acelerada`, `reducao_de_dano`, `familiar`, efeitos `"ver_texto"`).
- `bin/build_db` descartava `costs` dos poderes, `precos_adicionais` dos materiais especiais, as propriedades dos escudos e o Broquel inteiro.
- `Melhoria#applicable_to` vinha como lista dentro de lista.
- `Pocao.medias()` (TypeScript) filtrava `"media"` em vez de `"medio"` e sempre retornava vazio.
- `Pericia#trained_only?`, `#armor_penalty?` e `#resistance_skill?` eram privados.

### Problemas conhecidos

- Nenhum JSON de classe tem `spellcasting`: `Classe.conjuradores` retorna vazio.
- O poder `esgrimista` existe em `guerreiro` e `bucaneiro` com o mesmo id; só um deles fica no banco.
- O índice remissivo cobre apenas parte do livro básico; `book_reference` é `nil` para o restante.

## [0.2.1] - 2024-12-06

- Corrige a busca do caminho do banco de dados.

## [0.2.0] - 2024-12-06

- Adiciona magias ao módulo Ruby.

## [0.1.0] - 2024-12-05

- Initial release
