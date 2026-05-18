const pool = require('../config/database');

async function migrate() {
    const connection = await pool.getConnection();
    try {
        console.log('Adicionando coluna created_by à tabela pacientes...');
        
        // Verificar se a coluna já existe
        const [columns] = await connection.execute('SHOW COLUMNS FROM pacientes LIKE "created_by"');
        
        if (columns.length === 0) {
            await connection.execute('ALTER TABLE pacientes ADD COLUMN created_by VARCHAR(36) NULL AFTER ativo');
            await connection.execute('ALTER TABLE pacientes ADD CONSTRAINT fk_pacientes_utilizador_creator FOREIGN KEY (created_by) REFERENCES utilizadores(id) ON DELETE SET NULL');
            console.log('Coluna created_by adicionada com sucesso.');
        } else {
            console.log('Coluna created_by já existe.');
        }
        
    } catch (error) {
        console.error('Erro na migração:', error);
        throw error;
    } finally {
        connection.release();
    }
}

migrate()
    .then(() => {
        console.log('Migração concluída.');
        process.exit(0);
    })
    .catch((err) => {
        console.error('Erro na migração:', err);
        process.exit(1);
    });
