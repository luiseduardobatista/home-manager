{
  pkgs,
  lib,
  isNixOS,
  ...
}: {
  home.packages = with pkgs;
    [
      rustup
    ]
    ++ lib.optionals isNixOS [
      python3
      go
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
