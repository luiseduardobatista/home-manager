{pkgs-unstable, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;
    settings = {
      plugin = [
        "opencode-gemini-auth@latest"
        "oh-my-opencode-slim"
      ];
      agent.explore.disable = true;
      agent.general.disable = true;
      lsp = true;
    };
  };
}
