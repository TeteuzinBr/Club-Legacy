# Análise estática do XAPK

Arquivo analisado: `com.monkeyibrow.worldsoccerchamps_2026.12.xapk`.

## Identificação

- O pacote identifica o jogo como **World Soccer Champs**, pacote Android `com.monkeyibrow.worldsoccerchamps` (versão 2026.12, código 468).
- O XAPK é um contêiner com o APK principal e pacotes separados de dados, arquitetura ARM64, idioma e texturas.
- O jogo é compilado com **Cocos2d-x** e sua lógica nativa está em `libWorldSoccerChamps.so` para ARM64. O XAPK não contém um projeto Godot, Unity ou código-fonte C++ legível que possa ser simplesmente reaberto e convertido.
- Os bancos `main.db` e `template*.db` não puderam ser lidos como SQLite comum. Os dados parecem protegidos/obfuscados; portanto, esta análise não afirma ter recuperado os elencos reais ou o esquema completo do banco.

## Estrutura funcional observada

- Há arquivos de configuração de lances, táticas e tutoriais, arquivos de localização e atlas de sprites separados para telas de equipe, gestão do elenco e partida.
- O pacote inclui 49 definições de lances e recursos próprios de partida (campo, bola, efeitos, áudio). Isso é consistente com partidas organizadas em momentos jogáveis, em vez de uma partida contínua de 22 jogadores controlados livremente.
- A descrição pública do jogo documenta os gestos principais: tocar em um companheiro para passar, tocar no espaço para movimentar e deslizar em direção ao gol para chutar; na defesa, o gesto de desarme é usado sem a bola.
- A interface tem fluxos de carreira, escolha de liga/clube, calendário, classificação, escalação/formação, estatísticas e transferências. A ficha de elenco usa atributos de jogador como velocidade, passe, chute e desarme.

## O que isso significa para o projeto Godot

O protótipo existente foi atualizado para usar os gestos de passe/movimento/chute/desarme e para apresentar lances-chave. Ele **ainda não é uma cópia visual ou funcional idêntica**: menus, animações, regras, dados reais, elencos completos e conteúdo original do jogo não foram recuperados. O protótipo continua com 10 ligas de exemplo, oito clubes por liga e jogadores fictícios gerados localmente.

Uma reprodução fiel exigiria reconstruir as telas, regras e sequências a partir de referências visuais e comportamentais verificáveis. A biblioteca nativa compilada e os bancos protegidos não fornecem o código-fonte nem os dados legíveis para fazer uma conversão automática. Os binários, sprites, áudios e banco do jogo original não foram incorporados ao projeto.

## Comparação com o vídeo enviado

O vídeo `XSutn6KrbDY` mostra uma carreira de World Soccer Champs com o Boavista. As telas que usei como referência foram:

- **1:21 e 16:28 — painel da carreira:** cabeçalho verde com o clube, faixa com ano/semana e vários cartões compactos para próximo jogo, gestão do time, treino, calendário, liga, transferências, academia, olheiros e estatísticas.
- **2:19 — gestão do time:** campo ocupa o lado esquerdo, os jogadores aparecem como marcadores com nota/posição/nome, e o painel claro de suplentes e reservas fica à direita.
- **7:03 e 21:10 — partida:** placar e minuto em uma faixa superior dividida por cores; campo visto de cima com faixas verde-amareladas.
- **9:24 — classificação:** cabeçalho roxo da competição, abas de artilheiros/assistências e tabela com jogos, vitórias, empates, derrotas, gols e pontos.
- **14:07 — transferências de saída:** bloco de ofertas recebidas acima da lista de venda rápida.

O Godot agora segue essas composições e navegação nas telas de carreira, elenco, classificação, calendário, transferências e partida. Os nomes e valores usados continuam vindo do protótipo, portanto não são os dados do vídeo ou do jogo original.

## Fontes públicas consultadas

- [Google Play — World Soccer Champs](https://play.google.com/store/apps/details?id=com.monkeyibrow.worldsoccerchamps)
- [App Store — World Soccer Champs](https://apps.apple.com/us/app/world-soccer-champs/id1516548776)
- [Uptodown — descrição de controles e partidas](https://world-soccer-champs.en.uptodown.com/android)
