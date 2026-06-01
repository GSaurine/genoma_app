# Guia de Deploy de Homologação (Passo a Passo) - Railway & Vercel

Este guia descreve como colocar a aplicação online utilizando o Railway para o Backend/Banco de Dados e Vercel para o Frontend.

## 1. Preparação do Backend (Railway.app)

O Railway lerá seu `docker-compose.yml` e criará os serviços automaticamente.

1. **Criar Projeto:** No Railway, selecione `New Project` > `Deploy from GitHub repo`.
2. **Serviços Gerados:** Ele criará um serviço para o `mysql` e outro para o `backend`.
3. **Configuração de Variáveis (Essencial):**
   No serviço do **Backend**, vá em `Variables` e garanta que estas variáveis estejam apontando para o serviço MySQL do Railway:
   - `DB_HOST`: `${{mysql.MYSQLHOST}}`
   - `DB_PORT`: `${{mysql.MYSQLPORT}}`
   - `DB_USER`: `${{mysql.MYSQLUSER}}`
   - `DB_PASSWORD`: `${{mysql.MYSQLPASSWORD}}`
   - `DB_NAME`: `${{mysql.MYSQLDATABASE}}`
   - `JWT_SECRET`: (Uma chave segura)
   - `PORT`: `3000`
   - `CORS_ORIGIN`: (O link que a Vercel vai gerar)

## 2. Preparação do Frontend (Flutter Web na Vercel)

1. **Build Local (Opcional):**
   - Na pasta `genoma/`: `flutter build web --release`.
2. **Na Vercel:**
   - Conecte o repositório.
   - **Framework Preset:** `Other`.
   - **Root Directory:** `genoma` (ou a pasta onde está seu projeto flutter).
   - **Output Directory:** `build/web`.
   - **Build Command:** `flutter build web --release`.

## 3. Diagnóstico de Erros Comuns no Railway

- **Error: "No start script found":** Verifique se o `package.json` dentro da pasta `backend` tem um script `"start": "node server.js"`.
- **Error: "Connection refused":** Verifique se o banco de dados terminou de subir antes do backend.
- **Error: "Invalid Variables":** Certifique-se de que os nomes das variáveis (DB_HOST, etc) batem com o que o seu código espera em `backend/src/config/environment.js`.

---
*Nota: Para qualquer dúvida técnica durante o processo, consulte as diretrizes de arquitetura no histórico do projeto.*


---
*Nota: Para qualquer dúvida técnica durante o processo, consulte as diretrizes de arquitetura no histórico do projeto.*
