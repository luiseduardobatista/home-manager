{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Conta do GitHub (Pessoal)
      Host github
        HostName github.com
        User git
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/id_rsa_pessoal
        IdentitiesOnly yes

      # Conta do GitHub (Kyros)
      Host github-kyros
        HostName github.com
        User git
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/id_rsa_kyros
        IdentitiesOnly yes

      # Conta do GitLab Kyros
      Host gitlab-kyros
        HostName git.kyros.com.br
        User git
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/id_rsa_kyros
        IdentitiesOnly yes

      # Conta do GitLab FatorRH
      Host gitlab-fatorrh
        HostName git.gcpecfatorrh.com.br
        User git
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/id_rsa_kyros

      # Conta do GitLab FatorRH
      Host gitlab-a10
        HostName git.a10inteligenciafiscal.com.br
        User git
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/id_rsa_kyros
        IdentitiesOnly yes
       IdentitiesOnly yes
    '';
  };
}
