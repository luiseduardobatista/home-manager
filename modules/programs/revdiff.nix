{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.revdiff.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."revdiff/config".text = ''
    line-numbers = true
  '';
}
