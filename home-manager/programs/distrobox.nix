{
  config,
  pkgs,
  ...
}: {
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;

    settings = {
      container_manager = "docker";
      container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro /run/current-system/sw:/run/current-system/sw:ro";
    };

    containers = {
      dev = {
        image = "ubuntu:24.04";
        pull = true;

        additional_packages = [
          "git"
          "curl"
          "wget"
          "build-essential"
          "python3"
          "python3-pip"
          "python3-venv"
          "fish"
          "zsh"
          "sudo"
          "software-properties-common"
          "ca-certificates"
        ];

        init_hooks = [
          # --- SOLUÇÃO PARA O PROBLEMA DO CONTAINER ESTAR USANDO O SUDO DO HOST---
          # 1. Cria um "ponto de verdade" em /usr/local/bin (que tem prioridade padrão)
          "ln -sf /usr/bin/sudo /usr/local/bin/sudo"

          # 2. Garante que /usr/local/bin esteja SEMPRE no início do PATH para Bash/Zsh/Sh
          # Cria um script que roda no login e força o prepend do caminho.
          "echo 'export PATH=/usr/local/bin:$PATH' > /etc/profile.d/00-force-local-path.sh"
          "chmod +x /etc/profile.d/00-force-local-path.sh"

          # 3. Garante que /usr/local/bin esteja SEMPRE no início do PATH para Fish
          # A flag --move garante que, mesmo se já existir, ele vai para o topo da lista.
          "mkdir -p /etc/fish/conf.d"
          "echo 'fish_add_path --prepend --move /usr/local/bin' > /etc/fish/conf.d/00-force-local-path.fish"
          # ------------------------------------

          "curl -LsSf https://astral.sh/uv/install.sh | sh"
          "export DEBIAN_FRONTEND=noninteractive"
          "apt-get update && apt-get install -y locales"
          "locale-gen pt_BR.UTF-8"

          "curl https://mise.run | sh"
          ''echo '~/.local/bin/mise activate fish | source' > /etc/fish/conf.d/mise-activate.fish''
          "~/.local/bin/mise install -y"

          ''echo 'export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/${config.home.username}/bin' >> /etc/profile''
          ''echo 'fish_add_path --path --append /run/current-system/sw/bin /etc/profiles/per-user/${config.home.username}/bin' > /etc/fish/conf.d/nix-host-path.fish''
        ];
      };
    };
  };
}
