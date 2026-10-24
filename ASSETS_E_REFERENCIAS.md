# Imagens e referências

## Referências visuais

- Vídeo analisado: [O NOVO INICIO DO ZERANDO O WORLD SOCCER CHAMPS](https://www.youtube.com/watch?v=0qDZO6JGZ-c). Serviu de referência para a lista de países e ligas, a faixa de identidade do clube, o painel da carreira e a tela de gestão do time.
- Os nomes, marcas e imagens de clubes pertencem aos respectivos titulares. Este protótipo não é afiliado ao World Soccer Champs nem aos clubes.

## Arquivos incluídos

- `assets/flag-icons/`: bandeiras SVG do projeto [lipis/flag-icons](https://github.com/lipis/flag-icons), sob licença MIT. O arquivo de licença está junto dos arquivos.
- `assets/football-logos-source/logos/`: escudos de clubes do projeto [JoseArroyave/football-logos](https://github.com/JoseArroyave/football-logos), cujo repositório declara licença MIT. Os créditos e termos estão na pasta do projeto.
- Logos das competições inglesa, italiana, norte-americana, japonesa, alemã e francesa são baixadas sob demanda do Wikimedia Commons: [Premier League](https://commons.wikimedia.org/wiki/File:Pl-logo-light.svg), [Serie A](https://commons.wikimedia.org/wiki/File:Serie_A_logo_2022.svg), [MLS](https://commons.wikimedia.org/wiki/File:MLS_Official_Logo.svg), [J3 League](https://commons.wikimedia.org/wiki/File:J3_league_logo_2026.svg), [Bundesliga](https://commons.wikimedia.org/wiki/File:Bundesliga_logo.svg) e [Ligue 1](https://commons.wikimedia.org/wiki/File:Ligue1.svg). As páginas originais apresentam as licenças e observações de marca; a marca da MLS está sob CC BY-SA 4.0.
- `assets/league-data-source/`: catálogo de nomes de competições do [openfootball/leagues](https://github.com/openfootball/leagues). Esse catálogo não contém elencos reais completos.
- `assets/openfootball_world_catalog.json` e `assets/openfootball_major_catalog.json`: nomes de ligas e clubes extraídos dos repositórios públicos CC0 [openfootball/world](https://github.com/openfootball/world), [england](https://github.com/openfootball/england), [espana](https://github.com/openfootball/espana), [deutschland](https://github.com/openfootball/deutschland), [italy](https://github.com/openfootball/italy), [europe](https://github.com/openfootball/europe), [south-america](https://github.com/openfootball/south-america) e [FerrerasRP/FootballData](https://github.com/FerrerasRP/FootballData). As Séries B, C e D do Brasil usam a base CC0 FootballData; os demais catálogos vêm dos repositórios OpenFootball. Os scripts em `tools/` documentam como gerar os catálogos.
- A página de [tabelas do GE](https://interativos.ge.globo.com/tabelas/) foi consultada como referência para os campeonatos principais. Seus nomes, escudos e tabelas não foram copiados. Competições femininas e categorias de base estão fora do escopo; nem todas as tabelas masculinas do GE já estão cobertas.

O jogo oferece 30 ligas masculinas em 14 países, com 663 vagas de clubes. O Brasileirão inclui as Séries A, B, C e D. As divisões disponíveis variam por país e fonte; o catálogo aberto lista clubes participantes, não elencos de jogadores. Clubes sem escudo incluído usam emblemas genéricos gerados pelo jogo.

## Elencos reais adicionados

Os elencos com nomes, posições e camisas reais foram transcritos para os clubes cobertos pelas fontes oficiais abaixo. As notas/atributos de jogo continuam sendo estimativas aleatórias do protótipo, não dados oficiais dos clubes.

- Flamengo (temporada 2026): [elenco oficial](https://hmlhub.flamengo.com.br/futebol/elenco); a lista de números foi conferida na relação [atualizada em outubro de 2026](https://flavoz.com.br/elenco-flamengo-2026/) e em páginas oficiais de jogadores.
- Palmeiras (temporada 2026): [elenco profissional oficial](https://www.palmeiras.com.br/elenco/).
- Barcelona (temporada 2026/27): [números oficiais da equipe principal](https://www.fcbarcelona.com/en/football/first-team/news/4570894/202627-first-team-jersey-numbers-confirmed).
- Roasso Kumamoto (temporada 2026): [elenco oficial](https://roasso-k.com/index.php/clubteam/players).

Os elencos desses quatro clubes foram incluídos no código. Os demais clubes ainda usam nomes gerados pelo protótipo. As notas e atributos de todos os jogadores são valores de jogo criados pelo protótipo, não avaliações oficiais.
