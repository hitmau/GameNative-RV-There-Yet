# RV There Yet? via cópia local no GameNative

Este ajuste usa o fluxo **Custom Game** do GameNative: os arquivos vêm da instalação local do usuário e são importados para o armazenamento gerenciado pelo app. Não é necessário autenticar a biblioteca Steam para importar essa pasta. O próprio jogo ainda pode exigir serviços Steam/EOS, especialmente para recursos online; o patch não remove nem falsifica essas verificações.

## APK para instalar

Depois de compilar, o APK fica em `app/build/outputs/apk/modern/rvthereyet/app-modern-rvthereyet.apk`. É uma variante ARM64 para teste, assinada com a chave de depuração local. Ela usa o identificador `app.gamenative.rvthereyet` e o nome **GameNative - RV There Yet**, então pode coexistir com o GameNative oficial sem desinstalá-lo nem apagar seus dados. O script ADB instala esse APK automaticamente. Para instalação manual, copie o APK para o telefone e abra-o.

## Copiar e importar o jogo

1. Conecte o telefone por USB com Depuração USB ativada e aceite a autorização ADB.
2. No PC, rode `tools/transfer_rv_there_yet.ps1 -WhatIf`. Com um telefone conectado, a prévia confere o espaço livre; sem telefone, informa a estimativa e não transfere nada.
3. Rode o script sem `-WhatIf`. Ele copia a instalação inteira para uma nova pasta em `Download`, compara os tamanhos do executável e dos arquivos `.ucas`/`.utoc` no telefone com os originais e instala o APK separado. A origem no Steam fica intacta. Use `-SkipAppInstall` se quiser instalar o APK manualmente.
4. Abra **GameNative - RV There Yet**, entre na biblioteca local e adicione/importa um **Custom Game**. Escolha a pasta `Ride` que contém `Ride.exe`, a subpasta `Ride` e `Engine`.
5. Mantenha desativada a opção de apagar a origem até o jogo abrir. O GameNative copia os arquivos para sua área gerenciada; reserve cerca de duas vezes o tamanho do jogo mais espaço para o runtime. A prévia usa uma margem configurável de 5 GiB para esse runtime; isso é estimativa, não garantia de espaço suficiente para cada dispositivo.
6. Inicie o jogo pela biblioteca local. O perfil seleciona `Ride/Binaries/Win64/Ride-Win64-Shipping.exe` automaticamente.

O APK não embute o filesystem Linux/Wine nem o driver gráfico do dispositivo. Na primeira execução o GameNative pode baixar dependências e arquivos-base; isso precisa de internet e espaço adicional, mas não de autenticação da biblioteca Steam. A autenticação/DRM do próprio jogo permanece fora desta adaptação.

## O que o perfil detecta

O diretório Steam `Ride` contém dois executáveis que podem ser confundidos:

- `Ride.exe`: bootstrapper pequeno.
- `Ride/Binaries/Win64/Ride-Win64-Shipping.exe`: executável real do jogo.

O perfil local reconhece o jogo apenas quando encontra o executável Shipping, conteúdo IoStore `.ucas`/`.utoc` e `Engine/Binaries`. Então mostra **RV There Yet?** e seleciona o executável Shipping automaticamente. Nenhum arquivo do jogo é copiado para este repositório.

Também é possível copiar `D:\SteamLibrary\steamapps\common\Ride` para o telefone por MTP e instalar manualmente o APK descrito acima, continuando na etapa 4. O script pode receber `-DeviceSerial` quando mais de um aparelho estiver conectado e `-RuntimeReserveGiB` para ajustar a margem de espaço.

## Limites

- Este fluxo não baixa nem autentica Steam. Ele inicia o executável Windows como jogo local.
- A presença de `steam_api64.dll` e `EOSSDK-Win64-Shipping.dll` significa que autenticação ou conexão ainda pode ser exigida pelo próprio jogo. Multiplayer e chat não foram comprovados no modo local.
- A página oficial lista GPU mínima Nvidia 970, recomenda Nvidia 3060 e pede banda larga; isso torna o desempenho no celular incerto, mas não substitui um teste no aparelho. [Requisitos oficiais no Steam](https://store.steampowered.com/app/3949040/RV_There_Yet/)
- Os dois testes do perfil RV There Yet passaram e o APK ARM64 foi compilado e teve a assinatura verificada. A suíte geral do projeto executou 4.827 testes: 157 falharam em outras áreas do app e 17 foram ignorados; nenhuma falha foi reportada em `RVThereYetProfileTest`.
- Não havia aparelho Android conectado para testar a instalação, a importação SAF nem o lançamento do jogo. O APK contém bibliotecas nativas ARM64; um emulador x86 do PC não testaria o mesmo caminho gráfico e de tradução que um aparelho Android ARM64.
- `steam_api64.dll` e `EOSSDK-Win64-Shipping.dll` estão na instalação. O modo Custom Game evita login Steam no GameNative, mas autenticação/serviços exigidos pelo próprio jogo e o multiplayer ainda não foram comprovados.

## Relação com o projeto Skyrim Android

O projeto Skyrim inspira a experiência de selecionar uma pasta própria, validar os arquivos necessários e mostrar um estado pronto antes de iniciar. A implementação de Skyrim é uma recompilação estática específica daquele jogo; não é um runtime genérico que possa ser transplantado para Unreal Engine. Este ajuste usa só esse padrão de fluxo. O checkout de Skyrim não declara uma licença de código na raiz, por isso nenhum código ou dado dele foi copiado.
