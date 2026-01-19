# Meus Dotfiles com Nix

Este repositório contém minhas configurações pessoais de sistema e ambiente de desenvolvimento, gerenciadas com [Nix](https://nixos.org/) e [Home Manager](https://github.com/nix-community/home-manager).

O projeto é híbrido, funcionando tanto como:

1. **NixOS:** Configuração completa do sistema operacional (Desktop e Laptop).
2. **Non-NixOS (Standalone):** Gerenciamento do `$HOME` em distribuições como Ubuntu, Fedora e Arch.

## Índice

* [Recursos](#recursos)
* [Instalação](#instalação)
  * [Em Outras Distribuições](#em-outras-distribuições-ubuntu-fedora-etc)
  * [No NixOS](#no-nixos)
* [Pós-Instalação](#pós-instalação)
* [Estrutura do Projeto](#estrutura-do-projeto)
* [Gerenciamento de Dotfiles](#gerenciamento-de-dotfiles)
* [Ambiente de Desenvolvimento](#ambiente-de-desenvolvimento)
* [Ambiente Desktop (GNOME)](#ambiente-desktop-gnome)
* [Testando com Docker](#testando-com-docker)
* [Tópicos Avançados](#tópicos-avançados)

## Recursos

* **Sistema Híbrido:** Configurações compartilhadas entre NixOS e outras distros (usando `nixGL` automaticamente para aceleração gráfica fora do NixOS).
* **Flatpaks Declarativos:** Uso do `nix-flatpak` para gerenciar apps como Zen Browser, Obsidian e Discord via código.
* **Segurança:** Integração profunda com **1Password** (GUI e Agente SSH).
* **Shell:** Zsh, Fish e Bash configurados com Starship. Workflow otimizado com **Sesh** + **Tmux** + **Fzf**.
* **DevEnv:**
  * **Mise:** Gerenciamento de versões de linguagens (Node, Go, Python).
  * **Distrobox:** Container `dev` (Ubuntu 24.04) pré-configurado com hooks de integração com o host.
  * **Neovim:** Baseado no LazyVim.
  * **IDEs JetBrains:** Configuração do IdeaVim sincronizada com a experiência do Neovim.
* **Aplicações Gráficas:** Wezterm, Kitty, Alacritty e Foot configurados de forma intercambiável.

## Instalação

### Em Outras Distribuições (Ubuntu, Fedora, etc)

Para instalar e configurar seu ambiente com um único comando, execute o script abaixo. Ele detecta a distribuição, instala o Nix, configura o Daemon e aplica o Home Manager.

```bash
git clone https://github.com/luiseduardobatista/home-manager.git ~/nix && cd ~/nix && ./install.sh
```

O script é idempotente; você pode executá-lo novamente para atualizações ou reparos.

### No NixOS

Se estiver em uma instalação limpa do NixOS:

1. Clone o repositório:

    ```bash
    git clone https://github.com/luiseduardobatista/home-manager.git ~/nix
    ```

2. Gere ou ajuste a configuração de hardware (`/etc/nixos/hardware-configuration.nix`) e coloque em `./nixos/hosts/<host>`.
3. Aplique a configuração (Desktop ou Laptop):

    ```bash
    # Para Desktop (Configurações Nvidia, Performance)
    sudo nixos-rebuild switch --flake .#desktop --extra-experimental-features 'nix-command flakes'

    # Para Laptop (Configurações TLP, Economia de bateria)
    sudo nixos-rebuild switch --flake .#laptop --extra-experimental-features 'nix-command flakes'
    ```

## Pós-Instalação

### Configuração do `sudo` (Para Non-NixOS)

Após a instalação, verifique se o `sudo` reconhece os binários do Nix. Caso contrário, adicione os caminhos ao `secure_path` no `/etc/sudoers`:

```text
Defaults    secure_path = /home/luisb/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/sbin:/bin:/usr/sbin:/usr/bin
```

## Estrutura do Projeto

* **`flake.nix`**: Define os inputs e as saídas (`nixosConfigurations` e `homeConfigurations`).
* **`nixos/`**: Configurações exclusivas do sistema operacional.
  * `common.nix`: Configurações base (Boot, Docker, Pipewire, Locale).
  * `hosts/`: Definições específicas de hardware.
* **`home-manager/`**: Configurações de usuário (agnósticas).
  * `home.nix`: Ponto de entrada do usuário.
  * `lib/helpers.nix`: Funções auxiliares.
  * `programs/`: Módulos de software (Git, Neovim, Wezterm, Distrobox).
  * `sessions/`: Configurações gráficas (GNOME, temas).

## Gerenciamento de Dotfiles

### Mutáveis vs Imutáveis (`linkApp`)

Nativamente, o Nix torna arquivos de configuração "somente leitura" (symlinks para a `/nix/store`). Para permitir edição rápida de configurações de aplicações (como `wezterm.lua` ou `init.lua`), utilizo uma função auxiliar chamada **`linkApp`**.

Ela cria um link simbólico direto do diretório do repositório (`~/nix/...`) para o `~/.config/...`.

**Exemplo:**

```nix
# Em programs/wezterm/default.nix
xdg.configFile."wezterm" = linkApp "wezterm";
```

Isso permite editar `~/nix/home-manager/programs/wezterm/config/wezterm.lua` e ver as mudanças imediatamente, sem precisar rodar um rebuild do Home Manager.

### Adicionando um Pacote Simples

Para adicionar um pacote simples ao sistema:

1. Abra `home-manager/programs/cli/default.nix` (ou arquivo equivalente).
2. Adicione o pacote à lista:

    ```nix
    home.packages = with pkgs; [
      pacote-novo
    ];
    ```

3. Aplique:
    * Non-NixOS: `home-manager switch --flake .`
    * NixOS: `sudo nixos-rebuild switch --flake .`

## Ambiente de Desenvolvimento

### Distrobox (`dev`)

Para evitar poluir o sistema base, utilizo um container Ubuntu chamado `dev`.

* Definido em `programs/distrobox/default.nix`.
* Possui **hooks** automáticos que corrigem permissões de `sudo` e injetam variáveis de ambiente (`PATH`, `Mise`) para integração transparente com o host.
* **Uso:** `db enter dev` ou alias `d`.

### Sesh + Tmux

Gerenciamento de sessões de terminal:

* No Fish, pressione `Ctrl + f`.
* Uma janela do **FZF** abrirá listando seus projetos.
* Ao selecionar, ele cria (ou anexa) uma sessão Tmux isolada para aquele projeto.

## Ambiente Desktop (GNOME)

A configuração transforma o GNOME em um Tiling Window Manager usando **Pop Shell**.

* **Gerenciamento de Janelas:**
  * `Super + Y`: Alternar Tiling mode.
  * `Super + Setas` (ou `hjkl`): Mover foco.
  * `Super + Shift + Setas`: Mover janelas.
* **Atalhos Gerais:**
  * `Super + T`: Terminal.
  * `Super + Q`: Fechar janela.
  * `Super + F`: Arquivos.

## Testando com Docker

Dockerfiles estão disponíveis para validar a instalação em ambientes limpos:

```bash
# Teste no Ubuntu
docker build -t home-manager-config .
docker run -it home-manager-config

# Teste no Fedora
docker build -f Dockerfile.fedora -t nix-fedora-config-test .
docker run --rm nix-fedora-config-test
```
