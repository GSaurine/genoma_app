/**
 * Configuração de Ambiente
 * Centraliza validação e acesso a variáveis de ambiente
 * Garante que valores padrão são usados quando apropriado
 */

const NODE_ENV = process.env.NODE_ENV || 'development';
const isDevelopment = NODE_ENV === 'development';

const parseList = (val) => (val ? val.split(',').map(s => s.trim()).filter(Boolean) : []);

// Lista de origens explícitas fornecidas via env
const corsWhitelist = parseList(process.env.CORS_ORIGIN || 'http://localhost:3000');

// Função origin para o pacote `cors` com comportamento seguro:
// - permite requests sem Origin (ex: curl / server-to-server)
// - permite origens na whitelist
// - em desenvolvimento permite dinamicamente qualquer localhost (qualquer porta)
// - em produção rejeita origens não declaradas
const corsOrigin = (origin, callback) => {
  if (!origin) return callback(null, true);
  if (corsWhitelist.includes(origin)) return callback(null, true);
  if (isDevelopment && /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin)) {
    return callback(null, true);
  }
  return callback(new Error('Origin not allowed by CORS'));
};

module.exports = {
  NODE_ENV,
  isDevelopment,
  isProduction: NODE_ENV === 'production',

  // Servidor
  PORT: parseInt(process.env.PORT, 10) || 3000,

  // Base de Dados
  DATABASE: {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT, 10) || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'genoma',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  },

  // JWT
  JWT: {
    secret: process.env.JWT_SECRET || 'default_secret_key_change_in_production',
    expiration: process.env.JWT_EXPIRE || '7d'
  },

  // CORS - origin é uma função para validação mais segura
  CORS: {
    origin: corsOrigin,
    optionsSuccessStatus: 200
  },

  // Rate Limiting
  RATE_LIMIT: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 15 * 60 * 1000,
    max: parseInt(process.env.RATE_LIMIT_MAX, 10) || 100,
    message: 'Muitas requisições deste IP, tente novamente mais tarde.'
  },

  // Logging
  LOG: {
    level: process.env.LOG_LEVEL || 'info',
    dir: process.env.LOG_DIR || './logs'
  }
};
