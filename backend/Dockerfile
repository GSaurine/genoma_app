# Use a imagem oficial do Node.js LTS (Lightweight)
FROM node:18-alpine

# Definir o diretório de trabalho
WORKDIR /app

# Instalar dependências necessárias para o entrypoint e healthcheck
# mariadb-client é usado no entrypoint.sh para verificar se o DB está pronto
RUN apk add --no-cache mariadb-client wget

# Copiar arquivos de definição de dependências
COPY package*.json ./

# Instalar dependências de produção
RUN npm install --omit=dev

# Copiar o restante do código fonte
COPY . .

# Garantir que o entrypoint tenha permissões de execução
RUN chmod +x entrypoint.sh

# A variável PORT é fornecida pelo Railway automaticamente
ENV PORT 3000
EXPOSE ${PORT}

# Healthcheck para monitorar a saúde da API
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

# Comando para iniciar a aplicação através do entrypoint (que executa migrações)
CMD ["./entrypoint.sh"]