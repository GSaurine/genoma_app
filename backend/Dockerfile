# Backend Dockerfile - Genoma API
FROM node:18-alpine

# Define diretório de trabalho
WORKDIR /app

# Copia package.json (e package-lock.json se existir)
COPY package.json ./
# Se houver package-lock.json, copia ele também
COPY package-lock.json* ./

# Instala dependências (usando install em vez de ci para maior flexibilidade no deploy inicial)
RUN npm install

# Instalar cliente MariaDB para permitir checagem de disponibilidade do DB
RUN apk add --no-cache mariadb-client

# Copia o código fonte
COPY . .

# Copia entrypoint e torna executável
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Expõe a porta da API
EXPOSE 3000

# Usar entrypoint que aguarda o DB, executa migrações e inicia a aplicação
ENTRYPOINT ["/entrypoint.sh"]