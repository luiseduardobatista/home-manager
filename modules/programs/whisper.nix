{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.whisper.packages.${pkgs.system}.default
  ];
}
