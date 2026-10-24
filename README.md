# Club Legacy

Protótipo de jogo de futebol e gerenciamento feito com Godot. Escolha um clube, monte o elenco e conduza sua carreira temporada após temporada.

## APK para teste

[Baixar Club Legacy para Android](https://github.com/TeteuzinBr/Club-Legacy/raw/main/dist/Club-Legacy-teste.apk)

O APK atual é uma versão de depuração para celulares Android com processador **ARM64**. Para instalar, baixe o arquivo no celular e permita a instalação de aplicativos dessa fonte quando o Android solicitar. O jogo precisa de acesso à internet para baixar bandeiras, escudos e logos de competições pelo menu **Imagens e armazenamento**. Depois do download, as imagens ficam guardadas no aparelho; o mesmo menu permite removê-las.

## Abrir o projeto

1. Clone o repositório com os submódulos:

   ```sh
   git clone --recurse-submodules https://github.com/TeteuzinBr/Club-Legacy.git
   ```

2. Abra `project.godot` no **Godot 4.7.2** e execute o projeto com **F6** ou **F5**.

## Controles

- **Seleção de clube:** setas para mudar de liga; `A` e `D` para mudar de clube; `Enter` para iniciar.
- **Elenco:** setas para trocar a formação; selecione dois jogadores para trocar suas posições.
- **Partida:** `WASD` ou setas para movimentar, `Espaço` para chutar, `J` para passar, `Q` para tentar desarmar e `Tab` para trocar de jogador. Também é possível jogar com toques e gestos na tela.
- Use **Simular** para encerrar a partida com um resultado automático.

## O que há no protótipo

- 30 ligas masculinas em 14 países, com 663 vagas de clubes. O Brasileirão tem Séries A, B, C e D; divisões adultas disponíveis também aparecem nos demais países.
- Carreira local com quatro slots de salvamento automático.
- Elenco, formações, mercado, calendário, classificação e partidas jogáveis ou simuladas.
- Downloads opcionais de bandeiras, escudos e logos de competições.

Parte dos clubes ainda usa jogadores gerados, e os atributos de jogo são estimativas do protótipo. Consulte [LEIA-ME.md](LEIA-ME.md) e [ASSETS_E_REFERENCIAS.md](ASSETS_E_REFERENCIAS.md) para mais detalhes, fontes e créditos.
