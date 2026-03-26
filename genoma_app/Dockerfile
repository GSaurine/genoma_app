# Flutter Web Dockerfile - Genoma App
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Instala dependências do sistema
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Copia arquivos do pubspec
COPY pubspec.yaml pubspec.lock ./

# Instala dependências Flutter
RUN flutter pub get

# Copia o código fonte
COPY . .

# Build para Web
RUN flutter build web --release

# Stage 2 - Servidor Web com Nginx
FROM nginx:alpine

# Copia o build do Flutter para o Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Remove configuração padrão e cria nova
RUN rm /etc/nginx/conf.d/default.conf

RUN printf 'server {\n\
    listen 80 default_server;\n\
    listen [::]:80 default_server;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    client_max_body_size 100M;\n\
    gzip on;\n\
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml application/javascript application/json;\n\
\n\
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {\n\
        expires 1y;\n\
        add_header Cache-Control "public, immutable";\n\
    }\n\
\n\
    location /api {\n\
        proxy_pass http://backend:3000;\n\
        proxy_http_version 1.1;\n\
        proxy_set_header Upgrade $http_upgrade;\n\
        proxy_set_header Connection "upgrade";\n\
        proxy_set_header Host $host;\n\
        proxy_set_header X-Real-IP $remote_addr;\n\
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n\
        proxy_set_header X-Forwarded-Proto $scheme;\n\
    }\n\
\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
\n\
    add_header X-Frame-Options "SAMEORIGIN" always;\n\
    add_header X-Content-Type-Options "nosniff" always;\n\
}\n' > /etc/nginx/conf.d/default.conf

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80 || exit 1

# Expõe a porta 80
EXPOSE 80

# Inicia o Nginx
CMD ["nginx", "-g", "daemon off;"]