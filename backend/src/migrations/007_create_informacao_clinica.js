module.exports.up = async (db) => {
  try {
    await db.execute(`
      CREATE TABLE IF NOT EXISTS informacao_clinica (
        id CHAR(36) PRIMARY KEY,
        processo_id CHAR(36) NOT NULL,
        semanas_gravidez INT,
        dias_gravidez INT,
        tipo_gravidez ENUM('singular', 'gemelar') DEFAULT 'singular',
        quer_saber_sexo BOOLEAN DEFAULT FALSE,
        motivo_prescricao TEXT,
        data_registo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_info_clinica_processo FOREIGN KEY (processo_id) REFERENCES processos(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela informacao_clinica criada');
  } catch (error) {
    console.error(`  ✗ Erro ao criar tabela informacao_clinica: ${error.message}`);
    throw error;
  }
};
