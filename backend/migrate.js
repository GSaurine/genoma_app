const mysql = require('mysql2/promise');
require('dotenv').config({ path: '../.env' });

async function runMigrations() {
  let connection;
  try {
    // Conectar diretamente sem pool
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || 'root',
      database: process.env.DB_NAME || 'genoma',
      ssl: false,
      supportBigNumbers: true,
      bigNumberStrings: true
    });

    console.log('Conectado à base de dados MariaDB com sucesso');

    // Primeiro, corrigir autenticação do utilizador
    try {
      try {
        await connection.execute(
          `ALTER USER '${process.env.DB_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${process.env.DB_PASSWORD}'`
        );
        console.log('✓ Autenticação do utilizador corrigida (localhost)');
      } catch (errLocal) {
        // tentar com host '%' caso o usuário tenha sido criado com host coringa
        try {
          await connection.execute(
            `ALTER USER '${process.env.DB_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${process.env.DB_PASSWORD}'`
          );
          console.log("✓ Autenticação do utilizador corrigida ('%')");
        } catch (errAny) {
          console.log('ℹ Não foi possível alterar o método de autenticação do utilizador (provavelmente não necessário)');
        }
      }
    } catch (error) {
      if (error.code === 'ER_PARSE_ERROR') {
        console.log('ℹ Autenticação já estava configurada');
      }
    }

    // Executar FLUSH PRIVILEGES
    try {
      await connection.execute('FLUSH PRIVILEGES');
      console.log('✓ Privilégios atualizados');
    } catch (error) {
      console.log('ℹ Privilégios já atualizados');
    }

    // Executar migrações
    const fs = require('fs');
    const path = require('path');
    const migrationsDir = path.join(__dirname, 'src', 'migrations');
    
    const files = fs.readdirSync(migrationsDir)
      .filter(f => f.endsWith('.js') && !f.startsWith('tables.js'))
      .sort();

    console.log(`\nExecutando ${files.length} migração(ões)...\n`);

    for (const file of files) {
      console.log(`→ Executando: ${file}`);
      try {
        const migration = require(path.join(migrationsDir, file));
        await migration.up(connection);
        console.log(`✓ ${file} executado com sucesso\n`);
      } catch (error) {
        console.error(`✗ Erro ao executar ${file}:`);
        console.error(`  ${error.message}\n`);
      }
    }

    console.log('✓ Processo de migrações finalizado');
    process.exit(0);
  } catch (error) {
    console.error('Erro ao conectar à base de dados:', error.message);
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

runMigrations();
