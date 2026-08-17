# Dotfiles com Nix

Configurações pessoais de sistema e ambiente de desenvolvimento, gerenciadas com [Nix](https://nixos.org/), [Home Manager](https://github.com/nix-community/home-manager) e [flake-parts](https://flake.parts/).

O projeto é híbrido e funciona como:

1. **NixOS:** configuração completa do sistema operacional (Desktop e Laptop).
2. **Standalone (Linux genérico):** gerenciamento do `$HOME` em distribuições como Ubuntu, Fedora e Arch, usando Home Manager com `targets.genericLinux` e `nixGL` para aceleração gráfica.

## Visão geral

- **`flake.nix`**: define inputs, `nixConfig` (substituters/trusted keys de Cachix), a estrutura `flake-parts` e os outputs.
- **`modules/`**: árvore modular organizada por domínio, com entrypoints `default.nix` explícitos (sem auto-import).
- **`install.py`**: instalador para Linux genérico (idempotente; instala Nix e aplica Home Manager).
- **`Dockerfile` / `Dockerfile.fedora`**: ambientes de teste limpos.

## Arquitetura

`flake.nix` usa `flake-parts` (`flake-parts.lib.mkFlake`) com o import:

```nix
imports = [
  inputs.flake-parts.flakeModules.modules
  ./modules
];
```

A árvore `modules/` é dividida por responsabilidade:

| Diretório | Responsabilidade |
|---|---|
| `modules/system/` | Responsabilidades do SO (boot, networking, locale, nix, ssh, audio, printing, docker, nix-ld, fonts, gnome system-level, v4l2loopback) |
| `modules/desktop/` | Sessão/DE/WM compartilháveis entre NixOS e Home Manager (GNOME, Niri, Noctalia) |
| `modules/programs/` | Aplicações e ferramentas (terminais, shell, tmux, neovim, git, etc.) |
| `modules/users/` | Identidade e composição do usuário (base comum `luis` + helpers) |
| `modules/hosts/` | Composição por máquina (`desktop`, `laptop`), incluindo hardware-configuration e classes `homeManager.host-*` |

Cada diretório tem um entrypoint `default.nix` que importa os módulos do domínio. Os módulos publicam suas opções por classe:

- `flake.modules.nixos.*` — módulos consumidos pela configuração NixOS;
- `flake.modules.homeManager.*` — módulos consumidos pelo Home Manager (integrado ao NixOS e standalone).

Os hosts são composição, não implementação: `desktop` e `laptop` importam o perfil `desktop` (que por sua vez importa a base `host`) e adicionam apenas hardware e diferenças reais da máquina.

## Outputs do flake

- `nixosConfigurations.desktop`
- `nixosConfigurations.laptop`
- `homeConfigurations.luisb` (Home Manager standalone)

## Home Manager

Home Manager funciona nos dois caminhos:

**Integrado ao NixOS** — via `home-manager.nixosModules.home-manager`, com `home-manager.users.luisb`, `useGlobalPkgs = true` e `useUserPackages = true` (o usuário `luisb` usa os `pkgs` do sistema).

**Standalone em Linux genérico** — via `home-manager.lib.homeManagerConfiguration`, com `targets.genericLinux.enable = true` e `nixGL` aplicado automaticamente nos terminais através do helper `gl` (em NixOS o helper devolve o pacote sem wrapper).

O provider `nix-flatpak` e os módulos de `noctalia` e `pi` são importados nos dois caminhos (NixOS integrado e standalone).

## Política de dotfiles

- **Configurações estáveis são declarativas**: use opções nativas do Home Manager (ex.: `programs.tmux.extraConfig`) ou `source = ./arquivo` para configurações cujo formato original seja melhor (arquivos copiados para a store).
- **Live / out-of-store** (somente Niri e Noctalia):
  - `modules/desktop/niri/config.kdl` → symlink para `~/.config/niri/config.kdl`;
  - `modules/desktop/noctalia/config.toml` → symlink para `~/.config/noctalia/config.toml`.

  Esses arquivos são editáveis diretamente no checkout (`~/nix`), sem `home-manager switch`; o hot reload é aplicado pelo próprio aplicativo.

## Instalação

### NixOS

1. Clone o repositório:

   ```bash
   git clone https://github.com/luiseduardobatista/home-manager.git ~/nix && cd ~/nix
   ```

2. Gere ou ajuste a configuração de hardware e coloque em `modules/hosts/<host>/hardware-configuration.nix`.
3. Aplique a configuração:

   ```bash
   sudo nixos-rebuild switch --flake ~/nix#desktop
   # ou
   sudo nixos-rebuild switch --flake ~/nix#laptop
   ```

### Standalone (Linux genérico)

```bash
git clone https://github.com/luiseduardobatista/home-manager.git ~/nix && cd ~/nix
python3 install.py
```

O script é idempotente: detecta a distribuição, instala o Nix (e dependências de sistema, se necessário), e aplica o Home Manager. Opções úteis: `--skip-nix`, `--skip-deps`, `--dry-run`.

## Atualização / rebuild

```bash
# NixOS
sudo nixos-rebuild switch --flake ~/nix#<host>

# Home Manager standalone
home-manager switch --flake ~/nix#luisb
```

## Ambiente de desenvolvimento

- **Shell:** Fish, Zsh e Starship; `sesh` + Tmux + `fzf` para gerenciar sessões de terminal (bind `Ctrl+Espaço` no Fish).
- **Tmux:** plugin `resurrect` (restauração de sessão) e `continuum` (auto-save/auto-restore).
- **Neovim:** config padrão clonada de `MiniMax` e configuração LazyVim, ambos clonados por activation do Home Manager.
- **Mise:** gerenciamento de versões de linguagens (Node, Go, Python, etc.).
- **Helix** como editor alternativo.
- **Terminais:** Foot como padrão (`TERMINAL=foot`); Kitty, Alacritty, WezTerm e Ghostty configurados como alternativas.

## Ambiente Desktop (GNOME)

GNOME com tiling por janelas via **Pop Shell** e **Forge**.

Atalhos principais:

- `Super + T` — abrir terminal;
- `Super + Q` — fechar janela;
- `Super + F` — abrir arquivos (home);
- `Super + Y` — alternar modo tiling (Pop Shell).

## Testando com Docker

```bash
# Ubuntu
docker build -t home-manager-config .
docker run -it home-manager-config

# Fedora
docker build -f Dockerfile.fedora -t nix-fedora-config-test .
docker run --rm nix-fedora-config-test
```