module.exports.up = async (db) => {
  try {
    await db.execute(`
      CREATE TABLE IF NOT EXISTS colheitas (
        id CHAR(36) PRIMARY KEY,
        processo_id CHAR(36) NOT NULL,
        posto_id CHAR(36) NOT NULL,
        data_prevista DATE,
        periodo ENUM('Manhã', 'Tarde', 'Noite'),
        data_efetiva DATETIME,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_colheitas_processo FOREIGN KEY (processo_id) REFERENCES processos(id) ON DELETE CASCADE,
        CONSTRAINT fk_colheitas_posto FOREIGN KEY (posto_id) REFERENCES postos(id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela colheitas criada');
  } catch (error) {
    console.error(`  ✗ Erro ao criar tabela colheitas: ${error.message}`);
    throw error;
  }
};
