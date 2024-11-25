# Configuração do Home Manager no Ubuntu

Descreve os passos necessários para configurar o `sudo` no Ubuntu para reconhecer os pacotes instalados via Home Manager e Nix.

## Passos para configurar o `sudo`

1. Abra o arquivo de configuração do `sudoers` com o editor de sua escolha:

    ```bash
    sudo vim /etc/sudoers
    ```

2. Localize a linha `secure_path`.

3. Modifique o valor de `secure_path` para incluir os diretórios de binários do Home Manager e do Nix, garantindo que todos os pacotes instalados através do Home Manager (e outros pacotes do Nix) possam ser encontrados pelo `sudo`.

    Exemplo de modificação do `secure_path`:

    ```
    Defaults    secure_path = /home/luisb/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/sbin:/bin:/usr/sbin:/usr/bin:/snap/bin
    ```

## Explicação dos diretórios

- `/home/luisb/.nix-profile/bin`: Diretório onde os binários do Home Manager estão localizados.
- `/nix/var/nix/profiles/default/bin`: Diretório do perfil padrão do Nix.
- Os outros diretórios como `/sbin:/bin:/usr/sbin:/usr/bin:/snap/bin` são os diretórios padrão do sistema.

Após essa configuração, o `sudo` será capaz de encontrar e executar binários instalados pelo Home Manager e Nix sem problemas.

