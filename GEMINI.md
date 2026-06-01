# Guia de Deploy de Homologação (Passo a Passo)

Este guia descreve como colocar a aplicação online (Backend e Frontend) para testes externos.

## 1. Preparação do Backend (Railway.app)

O Railway é ideal porque lê o seu `docker-compose.yml` e cria os serviços automaticamente.

1.  **Criar Conta:** Acesse [railway.app](https://railway.app/) e conecte com seu GitHub (ou e-mail).
2.  **Novo Projeto:** Clique em `New Project` > `Deploy from GitHub repo`.
3.  **Configurar Banco:** 
    *   O Railway identificará o serviço `mysql` no seu `docker-compose.yml`.
    *   Verifique se as variáveis em `backend/src/config/database.js` estão usando `process.env.DB_HOST`, etc.
4.  **Configurar Backend:**
    *   O Railway criará um domínio automático (ex: `genoma-backend-production.up.railway.app`). **Anote este link.**
    *   Certifique-se de que a variável `CORS_ORIGIN` no Railway inclua o domínio onde o frontend será hospedado.

## 2. Preparação do Frontend (Flutter Web)

1.  **Atualizar API URL:** 
    *   No arquivo `genoma/lib/core/config/envConfig.dart`, altere a `API_BASE_URL` para o link do backend gerado pelo Railway (não esqueça do `/api` no final).
2.  **Gerar Build:**
    *   Abra o terminal na pasta `genoma/`.
    *   Execute: `flutter build web --release`.
    *   Isso criará uma pasta em `genoma/build/web`.

## 3. Hospedagem do Frontend (Netlify / Vercel)

1.  **Netlify (Mais simples):**
    *   Acesse [app.netlify.com](https://app.netlify.com/).
    *   Faça login e vá em `Sites`.
    *   Arraste a pasta `genoma/build/web` para a área de upload.
2.  **Configuração Final:**
    *   O Netlify gerará um link (ex: `https://genoma-app.netlify.app`).
    *   Envie este link para o seu chefe.

## 4. Checklist de Teste (Antes de enviar)

- [ ] O backend está rodando? (Acesse `LINK_DO_RAILWAY/health`).
- [ ] O login funciona no link do Netlify?
- [ ] O banco de dados foi migrado? (O Railway deve rodar o `npm run migrate` se configurado no Dockerfile/Start script).

---
*Nota: Para qualquer dúvida técnica durante o processo, consulte as diretrizes de arquitetura no histórico do projeto.*
