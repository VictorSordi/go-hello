# Usar a imagem oficial do Go como base
FROM golang:1.21-bookworm

# Criar um usuário não privilegiado para rodar a aplicação
RUN useradd -m -s /bin/bash gouser

# Definir o diretório de trabalho no container
WORKDIR /app

# Copiar os arquivos de modulos do Go
COPY go.mod ./

# Baixar as dependências do Go
RUN go mod download

# Copiar o restante do código-fonte da aplicação para dentro do container
COPY main_test.go main.go Dockerfile ./

# Instalar dependências e compilar a aplicação Go
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --no-install-recommends \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    go build -v -o server

# Alterar a propriedade dos arquivos para o usuário não privilegiado
RUN chown -R gouser:gouser /app

# Definir o usuário não privilegiado para o contêiner rodar
USER gouser

# Expor a porta que a aplicação vai escutar
EXPOSE 8080

# Comando para rodar a aplicação
CMD ["/app/server"]