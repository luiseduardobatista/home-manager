{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "Host *" = {
        IdentityAgent = "~/.1password/agent.sock";
      };
    };
  };
}
