# GameNative

**Jogue no Android os jogos de PC que você já possui na Steam, Epic e GOG, com sincronização de saves.**

[English](README.md) · **Português (Brasil)**

[![Último lançamento](https://img.shields.io/github/v/release/utkarshdalal/GameNative?style=flat-square&logo=github&label=última+versão)](https://github.com/utkarshdalal/GameNative/releases/latest)
[![Estrelas no GitHub](https://img.shields.io/github/stars/utkarshdalal/GameNative?style=flat-square&logo=github&color=ffd700)](https://github.com/utkarshdalal/GameNative/stargazers)
[![Discord](https://img.shields.io/badge/Discord-entre+na+comunidade-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/2hKv4VfZfE)
[![Licença GPL-3.0](https://img.shields.io/badge/licença-GPL%203.0-blue?style=flat-square)](LICENSE)

[**Baixar**](https://github.com/utkarshdalal/GameNative/releases/download/v1.4.0/gamenative-v1.4.0.apk) · [**Discord**](https://discord.gg/2hKv4VfZfE) · [**Apoiar o projeto**](https://ko-fi.com/gamenative)

<p align="center">
  <a href="https://youtu.be/QqIChmAu2_A?si=Ha6xzTQXZA2H8HUN&t=53" target="_blank"><img src="https://img.youtube.com/vi/QqIChmAu2_A/hqdefault.jpg" alt="Assistir à demonstração do GameNative no YouTube" width="560"></a>
</p>

<p align="center">Clique na miniatura para assistir à demonstração no YouTube.</p>

> Esta tradução descreve o GameNative original. O trabalho experimental para importar RV There Yet? está na [branch da adaptação](https://github.com/hitmau/GameNative-RV-There-Yet/tree/codex/rv-there-yet-offline-import), e a execução no Android ainda não foi confirmada.

---

O GameNative permite executar no Android os jogos de PC das suas bibliotecas Steam, Epic e GOG, sem transmissão pela rede. Os saves são sincronizados na nuvem para você continuar no celular de onde parou no computador.

O projeto ainda está em desenvolvimento. Nem todo jogo funciona e alguns precisam de ajustes, mas a comunidade compartilha configurações conhecidas que podem ser aplicadas automaticamente. Consulte a [compatibilidade dos jogos](https://gamenative.app/compatibility).

## O que o aplicativo oferece

- Jogos que você possui na Steam, Epic, GOG e Amazon
- Sincronização de saves entre o computador e o celular
- Configurações conhecidas aplicadas automaticamente
- Controles físicos e toque, editor de controles e comandos na tela
- Suporte a DLCs, Oficina Steam e branches
- Comunidade de suporte no Discord
- Otimização de jogos para seu dispositivo (membros)
- Ajuda com IA para localizar e corrigir problemas (membros)

## Como usar

1. Baixe o APK pela página de [últimos lançamentos](https://github.com/utkarshdalal/GameNative/releases/latest).
2. Instale o aplicativo no Android.
3. Entre na sua conta Steam.
4. Instale um jogo pela biblioteca.
5. Toque em **Jogar**.

## Suporte

O canal mais rápido para obter ajuda é o [servidor Discord](https://discord.gg/2hKv4VfZfE). O projeto pede que dúvidas sejam direcionadas à comunidade, pois issues abertas no GitHub são fechadas automaticamente.

Veja também as [perguntas frequentes](FAQ.md). Para recursos pagos e apoio ao desenvolvimento, acesse o [Ko-fi](https://ko-fi.com/gamenative).

## Contribuição

Para participar do desenvolvimento, entre no canal **#development** do [Discord](https://discord.gg/2hKv4VfZfE). As tarefas que procuram colaboradores estão no [Trello do projeto](https://trello.com/b/vGRkFoAM/open-source-board).

### Ajudar com um jogo que não funciona

O projeto publica dados de compatibilidade em [GameNative/gamenative-compat](https://github.com/GameNative/gamenative-compat). Antes de começar uma correção, confira a issue do jogo e avise a comunidade que está trabalhando nela.

As correções podem envolver este repositório, o [proton-wine](https://github.com/GameNative/proton-wine), o [FEX](https://github.com/GameNative/FEX), os drivers gráficos ou uma configuração específica do jogo. Abra uma contribuição no repositório responsável e compartilhe o link na issue correspondente.

### Compilar o aplicativo

1. Após clonar o projeto, inicialize os submódulos:

   ```sh
   git submodule update --init --recursive
   ```

2. Abra o projeto no Android Studio e compile como um projeto Android. As dúvidas de desenvolvimento podem ser encaminhadas ao Discord.
3. **Chave da API SteamGridDB (opcional):** para buscar imagens de jogos personalizados, adicione sua chave ao arquivo `local.properties`:

   ```properties
   STEAMGRIDDB_API_KEY=sua_chave_aqui
   ```

   Obtenha a chave nas [preferências da SteamGridDB](https://www.steamgriddb.com/profile/preferences). Sem ela, o aplicativo funciona, mas não busca essas imagens.

## Análises e privacidade

O GameNative usa [PostHog](https://posthog.com) para coletar análises anônimas. Consulte a [Política de Privacidade](PrivacyPolicy/README.md) para os detalhes.

O aplicativo coleta eventos de início, encerramento, instalação e remoção de jogos para ajudar a melhorar a compatibilidade. Algumas métricas de uso de recursos, login, recomendações, ciclo do aplicativo e sincronização podem ser desativadas em **Configurações → Informações → Análises de uso**.

## Patrocínio

O projeto recebe patrocínio da [CodeRabbit](https://coderabbit.link/gnative). Você também pode apoiar o desenvolvimento pelo [Ko-fi](https://ko-fi.com/gamenative).

## Licença

O GameNative é distribuído sob a [GPL-3.0](LICENSE). Os créditos, avisos de copyleft e componentes de terceiros estão em [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES).

**Use o aplicativo apenas com jogos que você tem direito de utilizar.**
