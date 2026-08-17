{
  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
    users.users.luisb.extraGroups = ["docker"];
  };
}
