/**
 * Configuração do Pool de Conexão MariaDB
 * Centraliza criação e gerenciamento de conexões
 */

const mysql = require('mysql2/promise');
const environment = require('./environment');

const pool = mysql.createPool({
  host: environment.DATABASE.host,
  port: environment.DATABASE.port,
  user: environment.DATABASE.user,
  password: environment.DATABASE.password,
  database: environment.DATABASE.database,
  waitForConnections: environment.DATABASE.waitForConnections,
  connectionLimit: environment.DATABASE.connectionLimit,
  queueLimit: environment.DATABASE.queueLimit,
  supportBigNumbers: true,
  bigNumberStrings: true,
  charset: 'utf8mb4',
  collation: 'utf8mb4_unicode_ci',
  ssl: false,
  authPlugins: {
    sha256_password: () => () => environment.DATABASE.password
  }
});

// Log de conexão bem-sucedida
pool.on('connection', () => {
  if (environment.isDevelopment) {
    console.log('✅ Nova conexão ao banco de dados estabelecida');
  }
});

// Log de erros de conexão
pool.on('error', (err) => {
  console.error('❌ Erro de conexão ao banco de dados:', err.message);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    console.error('   Conexão foi deixada cair pelo servidor');
  } else if (err.code === 'PROTOCOL_ENQUEUE_AFTER_FATAL_ERROR') {
    console.error('   Muitas conexões falharam');
  } else if (err.code === 'PROTOCOL_ENQUEUE_AFTER_FATAL_ERROR') {
    console.error('   Sem conexão válida com o MySQL durante query');
  }
});

module.exports = pool;