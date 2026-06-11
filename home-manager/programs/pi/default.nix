{
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  programs.pi.coding-agent = {
    enable = true;
  };

  home.activation.clonePiDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!/usr/bin/env bash
    set -euo pipefail
    PI_DOTFILES_DIR="${config.home.homeDirectory}/.pi/agent"
    if [ ! -d "$PI_DOTFILES_DIR/.git" ]; then
      echo "Clonando o repositório PI em $PI_DOTFILES_DIR..."
      # Clonar para um diretório temporário e mover para não perder arquivos existentes
      TMP_DIR=$(mktemp -d)
      ${pkgs-unstable.git}/bin/git clone https://github.com/luiseduardobatista/pi.git "$TMP_DIR/repo"
      ${pkgs-unstable.coreutils}/bin/cp -r "$TMP_DIR/repo/." "$PI_DOTFILES_DIR/"
      ${pkgs-unstable.coreutils}/bin/chmod -R u+w "$PI_DOTFILES_DIR/"
      ${pkgs-unstable.git}/bin/git -C "$PI_DOTFILES_DIR" remote set-url origin git@github.com:luiseduardobatista/pi.git
      ${pkgs-unstable.coreutils}/bin/rm -rf "$TMP_DIR"
      echo "Repositório PI clonado. Execute 'pi update' para reinstalar pacotes."
    else
      echo "O repositório PI já existe. Pulando clone."
    fi
  '';
}
