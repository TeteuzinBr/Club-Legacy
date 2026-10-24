# Club Legacy

Protótipo em Godot com carreira local, tela de elenco, atributos, formações, mercado, calendário e classificação. O mercado permite contratar jogadores dentro da verba, negociar ofertas por atletas do elenco e desenvolver jogadores jovens entre temporadas. A partida pode ser jogada ou simulada e usa controles por gestos inspirados nos lances-chave de World Soccer Champs. A interface e os desenhos são feitos no próprio Godot, sem imagens ou código do jogo de referência.

## Abrir

1. Clone o projeto com `git clone --recurse-submodules https://github.com/TeteuzinBr/Club-Legacy.git`.
2. Instale Godot 4.x.
3. Importe `project.godot` no Godot.
4. Pressione **F5**.

## Controles

- Na seleção: setas trocam de liga; A/D trocam de clube; Enter inicia a carreira.
- Na tela de elenco: setas trocam a formação; clique em dois jogadores para trocar suas posições.
- Na partida: toque/clique num companheiro para passar; toque/clique num espaço vazio para correr; deslize/arraste para chutar ou tentar o desarme. No teclado: WASD/setas movem, Espaço chuta, J passa, Q tenta desarmar e Tab troca o jogador.
- Na partida, **Simular** encerra com um placar automático.

O protótipo oferece 30 ligas masculinas em 14 países, com 663 vagas de clubes. O Brasileirão tem Séries A, B, C e D. A lista também inclui divisões adultas disponíveis nas fontes para Inglaterra, Espanha, Alemanha, Itália, França, Países Baixos, Portugal e México; o Japão tem J1 e J3. A tela de ligas agrupa as competições por país e continua paginada. Os catálogos não incluem competições femininas nem categorias de base. Nem todos os países têm todas as divisões representadas nas fontes abertas consultadas.

A seleção mostra bandeiras e estrelas; escudos aparecem nas telas de seleção, calendário, classificação e partida. Ao avançar para a próxima partida, escolha **Jogar** ou **Simular**. Flamengo, Palmeiras, Barcelona e Roasso Kumamoto têm nomes, posições e camisas transcritos de elencos oficiais; os outros times ainda usam nomes gerados. Atributos seguem simulados. Ao fim da temporada, a colocação na liga afeta a verba, jogadores jovens podem evoluir e um atleta da base pode subir ao elenco. A carreira é salva automaticamente em um dos quatro slots.

O menu **Imagens e armazenamento** permite baixar/atualizar bandeiras, escudos e logos de competições, ou remover os escudos baixados. O perfil Android em `export_presets.cfg` já inclui a permissão de internet usada pelos downloads. As carreiras são salvas automaticamente em quatro slots; saves antigos em `user://career.cfg` são migrados para o slot 1.

Consulte `APK_ANALISE.md` para ver o que foi identificado no XAPK e os limites da análise.
Consulte `ASSETS_E_REFERENCIAS.md` para fontes, créditos e licenças das imagens.
