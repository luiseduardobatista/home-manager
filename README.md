# Meus Dotfiles com Nix

Este repositório contém minhas configurações pessoais de ambiente de desenvolvimento, gerenciadas com [Nix](https://nixos.org/) e [Home Manager](https://github.com/nix-community/home-manager). O objetivo é automatizar a configuração em diversas distribuições Linux (como Ubuntu, Fedora e Arch) de forma declarativa e reproduzível.

## Índice

* [Recursos](#recursos)
* [Começando](#começando)
* [Pós-Instalação](#pós-instalação)
* [Estrutura de Arquivos e Gerenciamento de Aplicações](#estrutura-de-arquivos-e-gerenciamento-de-aplicações)
* [Gerenciando Dotfiles](#gerenciando-dotfiles)
* [DE/TWM](#detwm)
* [Testando com Docker](#testando-com-docker)
* [Tópicos Avançados](#tópicos-avançados)

## Recursos

* **Gerenciamento de Pacotes:** Utiliza o Nix para instalar e gerenciar pacotes de forma isolada e consistente.
* **Configuração de Shell:** Inclui configurações para Zsh (com Oh My Zsh), Fish e Bash.
* **Ambiente de Desenvolvimento:** Configurações para Neovim (baseado no LazyVim), Git, SSH e outras ferramentas de desenvolvimento.
* **Aplicações de Desktop:** Gerencia a instalação e configuração de aplicações como Wezterm, Kitty, Brave e ferramentas de desenvolvimento com interface gráfica.
* **Instalação Automatizada:** Um script `install.sh` que detecta a distribuição e automatiza todo o processo de setup.
* **Ambiente de Testes:** Dockerfiles para testar as configurações em contêineres isolados do Ubuntu e Fedora.

## Começando

Para instalar e configurar seu ambiente com um único comando, execute o seguinte no seu terminal. Ele irá clonar o repositório e iniciar a instalação automaticamente.

```bash
git clone https://github.com/luiseduardobatista/home-manager.git ~/nix && cd ~/nix && ./install.sh
```

O script de instalação é idempotente, o que significa que você pode executá-lo novamente sem problemas se algo der errado.

## Pós-Instalação

### Configuração do `sudo` (Opcional)

Após a instalação, teste se o `sudo` consegue encontrar os programas instalados pelo Nix. Por exemplo:

```bash
sudo zsh --version
```

Caso você receba um erro de "comando não encontrado", significa que o `sudo` não está ciente dos novos caminhos. Para corrigir, você precisa ajustar a variável `secure_path` no arquivo `/etc/sudoers`.

1. Abra o arquivo com um editor de texto:

    ```bash
    sudo vim /etc/sudoers
    ```

2. Adicione os caminhos do Nix ao `secure_path`. O resultado deve ser semelhante a este:

    ```
    Defaults    secure_path = /home/luisb/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/sbin:/bin:/usr/sbin:/usr/bin
    ```

    > **Aviso:** Substitua `/home/luisb` pelo seu diretório home, se for diferente.

## Estrutura de Arquivos e Gerenciamento de Aplicações

A estrutura de arquivos foi projetada para ser modular e fácil de gerenciar. Todas as configurações do Home Manager estão no diretório `home-manager/`.

* **`home-manager/home.nix`**: Arquivo principal que importa todos os outros módulos de configuração.
* **`home-manager/packages/`**: Contém a lista de pacotes a serem instalados, divididos por categorias (ex: `cli.nix`, `gui.nix`, `dev.nix`).
* **`home-manager/dotfiles/`**: Armazena os arquivos de configuração (dotfiles) que são gerenciados e linkados para o seu diretório `~/.config`.
* **`home-manager/programs/`**: Configurações específicas de programas que são gerenciados pelo Home Manager (ex: Git, Zsh).

### Como Adicionar ou Remover uma Aplicação

Para adicionar ou remover uma aplicação do seu ambiente, siga estes passos:

1. **Encontrar o Arquivo de Pacotes Correto**

    Primeiro, decida em qual categoria a aplicação se encaixa. Por exemplo:

    * **Aplicações de linha de comando (CLI)** vão em `home-manager/packages/cli.nix`.
    * **Aplicações com interface gráfica (GUI)** vão em `home-manager/packages/gui.nix`.
    * **Ferramentas de desenvolvimento** vão em `home-manager/packages/dev.nix`.

2. **Adicionar ou Remover o Pacote**

    Abra o arquivo `.nix` correspondente e adicione ou remova o nome do pacote da lista. Para encontrar o nome correto do pacote, você pode pesquisar no [Nix Packages Search](https://search.nixos.org/packages).

    **Exemplo: Adicionando o `htop`**

    1. Abra o arquivo `home-manager/packages/cli.nix`.
    2. Adicione `htop` à lista de pacotes:

       ```nix
       {pkgs, ...}: {
         home.packages = with pkgs; [
           lazygit
           lazydocker
           btop
           tree
           zsh
           fish
           gemini-cli
           htop  # <-- Adicione o novo pacote aqui
         ];
       
         programs.zoxide.enable = true;
       }
       ```

    Para **remover** uma aplicação, basta apagar a linha correspondente.

3. **Aplicar as Mudanças**

    Após salvar o arquivo, aplique a nova configuração com o Home Manager:

    ```bash
    home-manager switch --flake .
    ```

    O Nix irá instalar (ou desinstalar) a aplicação e atualizar seu ambiente.

## Gerenciando Dotfiles

Este projeto utiliza uma abordagem centralizada para gerenciar *dotfiles* (arquivos de configuração, como `.bashrc` ou `kitty.conf`), garantindo que eles sejam consistentes e facilmente portáteis entre diferentes máquinas.

### Como Funciona?

1. **Diretório Central:** Todos os dotfiles são armazenados no diretório `home-manager/dotfiles/`. Cada subdiretório corresponde a uma aplicação específica (ex: `wezterm/`, `kitty/`, `fish/`).
2. **Links Simbólicos:** O arquivo `home-manager/dotfiles/main.nix` é responsável por criar links simbólicos (symlinks) dos arquivos de configuração deste repositório para os locais corretos no seu diretório `~/.config`.
3. **Automação com Nix:** Quando você executa o `home-manager switch`, o Nix lê a configuração em `main.nix` e garante que todos os links simbólicos sejam criados ou atualizados automaticamente.

### Como Adicionar um Novo Dotfile

Para gerenciar um novo arquivo de configuração, siga estes passos:

1. **Adicionar o Arquivo ao Repositório**

    Copie o arquivo ou diretório de configuração que você deseja gerenciar para dentro de `home-manager/dotfiles/`. Por exemplo, para o `alacritty`:

    ```text
    home-manager/dotfiles/alacritty/alacritty.yml
    ```

2. **Adicione sua Configuração à Lista de Links**

    O próximo passo é dizer ao Nix como criar o link para sua nova configuração. Abra o arquivo:

    `home-manager/dotfiles/main.nix`

    Dentro dele, localize a lista `dotfilesToLink`. Você tem duas opções para adicionar sua configuração:

    ---
    **Cenário 1: Link Direto (Nomes Iguais)**

    Use este método quando o nome do diretório em `dotfiles/` é o mesmo que você quer usar em `~/.config/`.

    * **Como fazer:** Adicione o nome da configuração como uma string simples.

        ```nix
        "alacritty"
        ```

    * **Resultado:** O Nix criará um link de `dotfiles/alacritty` para `~/.config/alacritty`.

    ---
    **Cenário 2: Link Customizado (Nomes Diferentes)**

    Use este método quando você quer que o nome do link em `~/.config/` seja **diferente** do nome do diretório de origem.

    * **Como fazer:** Adicione um bloco com `source` e `target`.
        * `source`: O nome original em `dotfiles/`.
        * `target`: O nome final que aparecerá em `~/.config/`.

        ```nix
        { source = "nvim"; target = "nvim-teste"; }
        ```

    * **Resultado:** O Nix criará um link de `dotfiles/nvim` para `~/.config/nvim-teste`.

    ---

    **Exemplo de lista `dotfilesToLink` combinando os dois cenários:**

    ```nix
    let
      # ...
      dotfilesToLink = [
        # --- Cenário 1: Links Diretos ---
        "wezterm"
        "foot"
        "kitty"
        "alacritty"

        # --- Cenário 2: Link Customizado ---
        # Linka o diretório 'dotfiles/nvim' para '~/.config/nvim-teste'
        { source = "nvim"; target = "nvim-teste"; }
      ];
    in
    # ...
    ```

3. **Aplicar as Mudanças**

    Execute o comando para aplicar a nova configuração do Home Manager:

    ```bash
    home-manager switch --flake .
    ```

    O Nix irá criar ou atualizar todos os links simbólicos conforme sua definição.

---

**Observação Importante**

Como usamos links simbólicos, se você apenas **editar o conteúdo** de um diretório ou arquivo já gerenciado, a mudança é aplicada instantaneamente. O comando `home-manager switch --flake .` só é necessário ao **adicionar, remover ou modificar a estrutura de um item** na lista `dotfilesToLink` em `main.nix`.

#### Exemplo Prático

Vamos supor que o diretório `alacritty` já está na sua lista `dotfilesToLink`. Isso significa que `~/.config/alacritty` é um link simbólico para `~/nix/home-manager/dotfiles/alacritty`.

##### Cenário 1: Modificando um arquivo existente

1. Você abre o arquivo de configuração principal: `~/nix/home-manager/dotfiles/alacritty/alacritty.yml`.
2. Você altera o tamanho da fonte (ex: `size: 12` para `size: 14`).
3. Ao salvar o arquivo, a mudança é aplicada **em tempo real**. Para aplicações como o Alacritty, que monitoram seu arquivo de configuração, você verá a fonte mudar imediatamente, sem precisar fechar e reabrir o terminal. Nenhum comando adicional é necessário.

##### Cenário 2: Adicionando ou deletando arquivos em um diretório gerenciado

1. Você decide separar seus temas em um novo arquivo. Você cria `~/nix/home-manager/dotfiles/alacritty/themes.yml`.
2. Como o *diretório inteiro* `alacritty` é um link simbólico, este novo arquivo aparece **automaticamente** em `~/.config/alacritty/themes.yml`.
3. Você pode então importá-lo no seu `alacritty.yml` principal. Se você deletar o arquivo, ele também desaparecerá instantaneamente.

Em ambos os casos, você não precisou executar `home-manager switch` porque as mudanças ocorreram *dentro* de um diretório que já estava sendo monitorado pelo Nix.

---

## DE/TWM

Esta seção detalha as configurações específicas para cada Ambiente de Desktop (DE) ou Gerenciador de Janelas (TWM) suportado.

<details>
<summary><strong>GNOME</strong></summary>

A configuração do GNOME é projetada para ser minimalista, focada em produtividade e orientada pelo teclado, transformando o ambiente de desktop padrão em um Tiling Window Manager (TWM) eficiente.

* **Tiling Window Manager com Forge:** A extensão [Forge](https://extensions.gnome.org/extension/4481/forge/) é o coração do setup, organizando as janelas em layouts de tiling automaticamente. Isso elimina a necessidade de gerenciar janelas manualmente e maximiza o uso do espaço da tela.
* **Interface Minimalista:** Extensões como [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/) são usadas para remover elementos da interface que causam distração, como o painel superior e pop-ups de notificação, resultando em um ambiente de trabalho mais limpo.
* **Workspaces Dinâmicos com Space Bar:** A extensão [Space Bar](https://extensions.gnome.org/extension/5357/space-bar/) cria uma barra de workspaces minimalista e eficiente, permitindo a navegação rápida entre áreas de trabalho.
* **Foco no Teclado:** Todos os atalhos de teclado foram remapeados para serem intuitivos e eficientes, permitindo que a maioria das ações (abrir apps, mover janelas, trocar de workspace) seja feita sem tocar no mouse.

O objetivo final é um ambiente de desktop que se sente como um TWM tradicional (como i3 ou Hyprland), mas com a estabilidade e integração do GNOME.

</details>

## Testando com Docker

Você pode testar as configurações em um ambiente limpo e isolado usando Docker.

### Teste no Ubuntu

```bash
docker build -t home-manager-config .
docker run -it home-manager-config
```

### Teste no Fedora

```bash
docker build -t nix-fedora-config-test -f Dockerfile.fedora .
docker run --rm nix-fedora-config-test
```

Dentro do contêiner, você pode verificar se os programas foram instalados corretamente:

```bash
zsh --version
nvim --version
```

## Tópicos Avançados

### Desenvolvendo Dependências Locais com `override-input`

A abordagem `--override-input` é a forma mais simples e idiomática do Nix para desenvolver e testar uma dependência (como sua configuração do Neovim) sem precisar fazer commits constantes.

#### O Conceito

Você diz ao Nix, na hora de executar o comando, para ignorar temporariamente uma das dependências definidas no seu `flake.nix` e, em vez disso, usar um diretório local.

Isso cria uma separação clara:

* **Modo Padrão (Estável):** O Nix usa a versão da sua configuração do Neovim que está "travada" no seu arquivo `flake.lock`. Isso garante que sua build seja sempre a mesma, estável e reproduzível.
* **Modo de Desenvolvimento (Flexível):** Você instrui o Nix a usar um clone local do seu repositório Neovim, onde você pode editar, salvar e testar livremente, sem a necessidade de fazer commits.

#### O Fluxo de Trabalho

1. **Clone de Desenvolvimento (Faça uma vez)**

    Tenha um clone do seu repositório `lazyvim` em um local conhecido. Este será seu "ambiente de testes".

    ```bash
    git clone git@github.com:luiseduardobatista/lazyvim.git ~/dev/lazyvim
    ```

2. **Ativar o Modo de Desenvolvimento**

    Quando quiser editar sua configuração do Neovim, execute o comando de build do Home Manager com a flag `--override-input`:

    ```bash
    home-manager switch --flake . --override-input lazyvim ~/dev/lazyvim
    ```

    * `--override-input`: A flag que ativa a mágica.
    * `lazyvim`: O nome da dependência no seu `flake.nix` que você quer substituir.
    * `~/dev/lazyvim`: O caminho para o diretório local que o Nix deve usar.

    O Nix irá então construir sua configuração usando os arquivos exatos que estão em `~/dev/lazyvim`, incluindo quaisquer alterações salvas, mas ainda não commitadas.

3. **Voltar para o Modo Estável**

    Quando terminar de editar e quiser voltar para sua configuração normal e reproduzível, simplesmente execute o comando sem a flag:

    ```bash
    home-manager switch --flake .
    ```

    O Nix voltará a usar a versão do `lazyvim` definida no seu `flake.lock`.

4. **"Salvar" suas Mudanças no Nix (Opcional, quando estiver pronto)**

    Depois de ter feito as alterações no seu clone de desenvolvimento (`~/dev/lazyvim`), feito o commit e o push para o GitHub, você pode "travar" essa nova versão no seu sistema Nix executando:

    ```bash
    nix flake update
    ```

    Isso atualizará o `flake.lock` para apontar para o seu commit mais recente, tornando-o o novo padrão para o "Modo Estável".

#### Vantagens

* **Simples:** Não precisa alterar seu código Nix com `if/else`.
* **Limpo:** Mantém a lógica de desenvolvimento fora do seu código de configuração.
* **Flexível:** Permite testar alterações não commitadas sem quebrar o estado do seu repositório principal.
* **Seguro:** É fácil voltar para um estado estável e conhecido.
