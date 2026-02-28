# Plano de Refatoração: Meus Dotfiles com Nix (Standalone Simplificado)

## Fase 1: Criação do Sistema de Flags (Options)

**1.1. Criar o arquivo `home-manager/options.nix`**
*   Criar um novo arquivo que irá declarar o módulo `my.desktop`.
*   Deve conter duas opções principais (usando `lib.mkEnableOption`):
    *   `my.desktop.gnome.enable`
    *   `my.desktop.niri.enable`

**1.2. Atualizar o `home-manager/home.nix` (Ponto de Entrada)**
*   Importar o novo arquivo `./options.nix`.
*   Remover a dependência do argumento `isNixOS` para controle de fluxo dentro deste arquivo.
*   Em vez de checar `isNixOS` para `xdg.userDirs` e dependências extras (como Cachix/Nix settings), atrelar configurações de GUI genéricas (não NixOS) com as propriedades de `targets.genericLinux`.
*   Mover as importações de `noctalia` e `dms` para as suas respectivas pastas de pacotes e não mais forçá-las no `imports` raiz do `home.nix`.

## Fase 2: Injetar as Flags Através do Flake e Remover `isNixOS`

**2.1. Ajustar o `flake.nix`**
*   No bloco `mkNixos` (dentro de `extraSpecialArgs`), passar `my.desktop.niri.enable = true;` (ou GNOME, conforme o host) no contexto de configuração dos usuários (`users.luisb = { ... }`).
*   No bloco `homeConfigurations."luisb"`, não há necessidade de ativar Niri ou GNOME, pois o padrão das flags criadas na Fase 1 será `false` (Standalone "limpo").
*   Manter temporariamente o argumento `isNixOS` nos `specialArgs` para não quebrar a compilação, mas iniciar a remoção de seu uso nos módulos filhos.

**2.2. Atualizar o `lib/helpers.nix`**
*   Modificar a função `gl = pkg: ...` para que, ao invés de usar `if isNixOS then pkg else wrap pkg`, avalie diretamente se as opções de targets genéricos estão ativas ou não.

## Fase 3: Encapsulamento das Sessões (GUI)

**3.1. Proteger o Niri e Componentes Relacionados**
*   Modificar `home-manager/sessions/niri/default.nix` para que todo o seu conteúdo esteja encapsulado em um `config = lib.mkIf config.my.desktop.niri.enable { ... };`.
*   Fazer o mesmo para as ferramentas exclusivas dele:
    *   `home-manager/programs/noctalia/default.nix`
    *   `home-manager/programs/dms/default.nix`

**3.2. Proteger o GNOME**
*   Modificar `home-manager/sessions/gnome/default.nix` e `home-manager/sessions/gnome/pop-shell/default.nix`.
*   Encapsular todas as 270+ linhas de `dconf` e pacotes GNOME dentro de `config = lib.mkIf config.my.desktop.gnome.enable { ... };`.

## Fase 4: Simplificação da Árvore de Arquivos (Módulos CLI)

**4.1. Migração e Absorção no `cli/default.nix`**
*   O arquivo `home-manager/programs/cli/default.nix` é uma lista de `home.packages`. Vamos mover os pacotes de módulos que *não* possuem arquivos de configuração próprios (apenas pacote) para dentro desta lista.
*   Alvos de migração (mover o pacote para `cli` e deletar a pasta de origem):
    *   `programs/dev-langs/` (Mover Python, Go, Rustup)
    *   `programs/jetbrains-toolbox/`
    *   `programs/1Password/` (Apenas a declaração autostart/GUI deve sumir. O SSH link será tratado na Fase 5).
    *   `programs/autostart/` (Deletar; não tem uso prático atualmente além de poluir a árvore).

**4.2. Atualizar `programs/default.nix`**
*   Remover as referências dos módulos deletados na etapa 4.1.

## Fase 5: Centralização de Symlinks (`linkApp` e `linkFile`)

**5.1. Criar o arquivo `home-manager/symlinks.nix`**
*   Criar este arquivo para conter uma definição massiva de `xdg.configFile`.
*   Usar os helpers `linkApp` e `linkFile` nativos para mapear todos os apps.
*   Listagem a ser construída neste arquivo:
    *   `alacritty`, `foot`, `kitty`, `wezterm`, `zed`, `zellij`, `helix`, `mise`, `flameshot`, `noctalia`, `1Password/ssh`.
    *   Configurações específicas com `linkFile`:
        *   Os 3 arquivos do `tmux`.
        *   O arquivo `.ideavimrc` (via `home.file`).
        *   Configuração do `niri/config` e `opencode`.

**5.2. Limpeza dos Módulos Residuais**
*   Abrir todos os `default.nix` em `programs/` (ex: `programs/kitty/default.nix`).
*   Deletar as linhas onde `xdg.configFile."xyz" = linkApp "xyz";` é chamado.
*   Esses arquivos devem conter apenas `home.packages` e parametrizações de variáveis de ambiente.

## Fase 6: Revisão e Validação Final

**6.1. Format e Lint**
*   Rodar `nix run nixpkgs#alejandra -- .` em todos os arquivos modificados para garantir o formato.
*   Rodar `nix run nixpkgs#statix -- check` para verificar anti-patterns gerados.

**6.2. Avaliação do Flake (Obrigatório)**
*   Rodar `nix flake check` no repositório.
*   Isso validará se os argumentos `isNixOS`, os módulos opcionais (`mkIf`), e as chaves deletadas não quebraram o build do `nixosConfigurations.desktop` e `homeConfigurations."luisb"`.

---

**Nota para Agentes Executores:**
Todas as alterações devem ser feitas passo a passo. A prioridade é remover complexidade (variáveis condicionais e checagens redundantes) favorecendo **Modularidade baseada em Flags** (`options`). Em caso de falha no `nix flake check`, faça `rollback` da etapa e corrija a sintaxe de chaves Nix (ex: evite `programs.foo.enable = true` espalhadas, use aninhamento agrupado para agradar o `statix`).