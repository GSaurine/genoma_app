/**
 * Ponto de entrada da aplicação
 * Responsável por:
 * 1. Carregar e validar variáveis de ambiente
 * 2. Inicializar a aplicação Express
 * 3. Iniciar o servidor HTTP
 */

// Carregar variáveis de ambiente ANTES de qualquer outra coisa
require('dotenv').config();

// Validar variáveis de ambiente necessárias
const requiredEnvVars = [
  'DB_HOST',
  'DB_USER',
  'DB_PASSWORD',
  'DB_NAME',
  'JWT_SECRET'
];

const missingEnvVars = requiredEnvVars.filter(env => !process.env[env]);
if (missingEnvVars.length > 0) {
  console.error(
    '❌ Erro: Variáveis de ambiente faltando:',
    missingEnvVars.join(', ')
  );
  console.error('📝 Crie um arquivo .env baseado em .env.example');
  process.exit(1);
}

// Importar app após carregar .env
const app = require('./src/app');

// Porta do servidor
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Iniciar servidor
const server = app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════════════════╗
║        🧬 API Genoma - Sistema de Laboratório Genómico    ║
╠════════════════════════════════════════════════════════════╣
║ Status:    ✅ Online e operacional                        ║
║ Porta:     🔌 ${PORT}                                           ║
║ Ambiente:  🌍 ${NODE_ENV}                                       ║
║ Hora:      ⏰ ${new Date().toLocaleString('pt-PT')}                  ║
╠════════════════════════════════════════════════════════════╣
║ Documentação da API:                                       ║
║   📖 http://localhost:${PORT}/api-docs                         ║
║                                                            ║
║ Health Check:                                              ║
║   ❤️  http://localhost:${PORT}/health                          ║
║                                                            ║
║ API Base URL:                                              ║
║   🔗 http://localhost:${PORT}/api                              ║
╚════════════════════════════════════════════════════════════╝
  `);
});

// Tratamento de erro de inicialização
server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`❌ Erro: Porta ${PORT} já está em uso`);
  } else {
    console.error('❌ Erro ao iniciar servidor:', err.message);
  }
  process.exit(1);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('\n⏹️  Recebido SIGTERM, encerrando gracefully...');
  server.close(() => {
    console.log('✅ Servidor encerrado');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('\n⏹️  Recebido SIGINT, encerrando gracefully...');
  server.close(() => {
    console.log('✅ Servidor encerrado');
    process.exit(0);
  });
});

// Tratamento de exceções não capturadas
process.on('uncaughtException', (err) => {
  console.error('❌ Exceção não capturada:', err);
  process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Promise rejection não tratada:', reason);
});

module.exports = server;
