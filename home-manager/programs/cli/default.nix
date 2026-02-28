{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  home.packages = with pkgs-unstable;
    [
      lazygit
      lazydocker
      btop
      tree
      gemini-cli
      sesh
      gnumake
      just
      unzip
      poetry
      openfortivpn
      golines
      gopls
      impl
      gotestsum
      air
      sqlc
      stow
      nodePackages.localtunnel
      eza
      cargo-nextest
      cargo-cache
      nixfmt-rfc-style
      statix
      uv
      alejandra
      fzf
      fd
      ripgrep
      xclip
      wget
      curl
      localtunnel
      bat
      rustup
      python3
      go
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.jetbrains-toolbox
    ];

  home.activation = {
    installRustStable = lib.hm.dag.entryAfter ["installPackages"] ''
      if ! ${pkgs.rustup}/bin/rustup default >/dev/null 2>&1; then
        echo "--- Configurando Rustup: Instalando toolchain stable como padrão ---"
        ${pkgs.rustup}/bin/rustup default stable
      else
        echo "--- Rustup: Toolchain stable já está configurado. Pulando... ---"
      fi
    '';
  };
}
