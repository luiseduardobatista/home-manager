# Configuração do Home Manager no Ubuntu (e outras distros)

Este repositório contém as configurações do Home Manager e um script de instalação (`install.sh`) projetado para automatizar a configuração do ambiente de desenvolvimento em diversas distribuições Linux (Ubuntu, Fedora, Arch Linux). O script é modular, idempotente e lida com a detecção da distribuição, instalação de dependências, configuração do Nix, Home Manager, shell padrão e Rust.

## Configuração do `sudo`

Para garantir que o `sudo` reconheça os pacotes instalados via Home Manager e Nix, é necessário ajustar o `secure_path` no arquivo de configuração do `sudoers`.

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

### Explicação dos diretórios

- `/home/luisb/.nix-profile/bin`: Diretório onde os binários do Home Manager estão localizados.
- `/nix/var/nix/profiles/default/bin`: Diretório do perfil padrão do Nix.
- Os outros diretórios como `/sbin:/bin:/usr/sbin:/usr/bin:/snap/bin` são os diretórios padrão do sistema.

Após essa configuração, o `sudo` será capaz de encontrar e executar binários instalados pelo Home Manager e Nix sem problemas.

## Desenvolvendo e Testando Dependências Locais com `override-input`

A abordagem `--override-input` é a forma mais simples e idiomática do Nix para desenvolver e testar uma dependência (como sua configuração do Neovim) sem precisar fazer commits constantes.

### O Conceito

Você diz ao Nix, na hora de executar o comando, para ignorar temporariamente uma das dependências definidas no seu `flake.nix` e, em vez disso, usar um diretório local.

Isso cria uma separação clara:
- **Modo Padrão (Estável):** O Nix usa a versão da sua configuração do Neovim que está "travada" no seu arquivo `flake.lock`. Isso garante que sua build seja sempre a mesma, estável e reproduzível.
- **Modo de Desenvolvimento (Flexível):** Você instrui o Nix a usar um clone local do seu repositório Neovim, onde você pode editar, salvar e testar livremente, sem a necessidade de fazer commits.

### O Fluxo de Trabalho

**Passo 1: Clone de Desenvolvimento (Faça uma vez)**

Tenha um clone do seu repositório `lazyvim` em um local conhecido. Este será seu "ambiente de testes".

```bash
git clone git@github.com:luiseduardobatista/lazyvim.git ~/dev/lazyvim
```

**Passo 2: Ativar o Modo de Desenvolvimento**

Quando quiser editar sua configuração do Neovim, execute o comando de build do Home Manager com a flag `--override-input`:

```bash
home-manager switch --flake . --override-input lazyvim ~/dev/lazyvim
```

- `--override-input`: A flag que ativa a mágica.
- `lazyvim`: O nome da dependência no seu `flake.nix` que você quer substituir.
- `~/dev/lazyvim`: O caminho para o diretório local que o Nix deve usar.

O Nix irá então construir sua configuração usando os arquivos exatos que estão em `~/dev/lazyvim`, incluindo quaisquer alterações salvas, mas ainda não commitadas.

**Passo 3: Voltar para o Modo Estável**

Quando terminar de editar e quiser voltar para sua configuração normal e reproduzível, simplesmente execute o comando sem a flag:

```bash
home-manager switch --flake .
```

O Nix voltará a usar a versão do `lazyvim` definida no seu `flake.lock`.

**Passo 4: "Salvar" suas Mudanças no Nix (Opcional, quando estiver pronto)**

Depois de ter feito as alterações no seu clone de desenvolvimento (`~/dev/lazyvim`), feito o commit e o push para o GitHub, você pode "travar" essa nova versão no seu sistema Nix executando:

```bash
nix flake update
```

Isso atualizará o `flake.lock` para apontar para o seu commit mais recente, tornando-o o novo padrão para o "Modo Estável".

### Vantagens

- **Simples:** Não precisa alterar seu código Nix com `if/else`.
- **Limpo:** Mantém a lógica de desenvolvimento fora do seu código de configuração.
- **Flexível:** Permite testar alterações não commitadas sem quebrar o estado do seu repositório principal.
- **Seguro:** É fácil voltar para um estado estável e conhecido.

## Testando a Configuração com Docker

Para testar a configuração do Home Manager em um ambiente isolado e reproduzível, você pode usar o `Dockerfile` fornecido. Este Dockerfile constrói uma imagem Ubuntu com o Nix e o Home Manager configurados, executando o script `install.sh` automaticamente.

### Construir a Imagem Docker

Navegue até a raiz do repositório e construa a imagem:

```bash
docker build -t home-manager-config .
```

### Executar o Contêiner

Após a construção, você pode executar um contêiner a partir da imagem. O `ENTRYPOINT` do Dockerfile (`./install.sh`) garantirá que o script de instalação seja executado. O `CMD` padrão (`/bin/bash -l`) fornecerá um shell interativo após a instalação.

```bash
docker run -it home-manager-config
```

Dentro do contêiner, você estará logado como o usuário `luisb` e poderá verificar se as configurações do Home Manager foram aplicadas corretamente. Por exemplo, você pode verificar a versão do `neovim` ou `zsh`:

```bash
nvim --version
zsh --version
```

Este método é ideal para validar suas alterações de configuração em um ambiente limpo antes de aplicá-las ao seu sistema principal.

