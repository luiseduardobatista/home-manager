# Usar a imagem base do Ubuntu 22.04 (LTS)
FROM ubuntu:22.04

# Evitar prompts interativos durante a instalação de pacotes
ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalar dependências do sistema
# Esta camada é cacheada e só será reconstruída se a lista de pacotes mudar.
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# 2. Criar usuário e conceder permissões de sudo
# O usuário é 'luisb' para alinhar com a configuração do Home Manager.
RUN useradd -m -u 1000 -s /bin/bash luisb && \
  echo "luisb ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 3. Criar o diretório de trabalho e definir 'luisb' como proprietário
RUN mkdir -p /home/luisb/nix-config && chown -R luisb:luisb /home/luisb/nix-config

# 4. Definir o diretório de trabalho e mudar para o usuário 'luisb'
WORKDIR /home/luisb/nix-config
USER luisb

# 5. Copiar os arquivos de configuração
# A camada de dependências acima permanecerá cacheada.
COPY --chown=luisb:luisb . .

# 6. Tornar o script de instalação executável
RUN chmod +x install.sh

# 7. Definir o ponto de entrada e o comando padrão.
# O ENTRYPOINT sempre executa o script de instalação.
# O CMD fornece o comando padrão (um shell bash) para ser executado após a instalação.
ENTRYPOINT ["./install.sh"]
CMD ["/bin/bash", "-l"]
