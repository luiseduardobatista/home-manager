# Usar a imagem base do Ubuntu 22.04 (LTS)
FROM ubuntu:22.04

# Evitar prompts interativos durante a instalação de pacotes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências básicas e sudo
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Criar um usuário não-root 'tester' para simular um ambiente de usuário real
# O usuário terá o ID 1000, comum em muitas distros desktop
RUN useradd -m -u 1000 -s /bin/bash tester

# Conceder privilégios de sudo sem senha ao usuário 'tester'
RUN echo "tester ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Definir o usuário 'tester' como o usuário padrão para os comandos subsequentes
USER tester

# Definir o diretório de trabalho na home do usuário
WORKDIR /home/tester/nix-config

# Copiar todo o conteúdo do projeto para o diretório de trabalho no contêiner
# O .dockerignore será respeitado aqui
COPY . .

# Tornar o script de instalação executável
RUN chmod +x install.sh

# Definir o ponto de entrada para executar o script de instalação
# O script será executado no modo interativo para que o menu de seleção de shell funcione
CMD ["/bin/bash", "-c", "./install.sh"]
