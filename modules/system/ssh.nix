{
  flake.modules.nixos.ssh = {
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  };
}
