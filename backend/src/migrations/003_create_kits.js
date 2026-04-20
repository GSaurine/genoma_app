module.exports.up = async (db) => {
  try {
    await db.execute(`
      CREATE TABLE IF NOT EXISTS kits (
        id CHAR(36) PRIMARY KEY,
        codigo_barras VARCHAR(50) UNIQUE NOT NULL,
        tipo_kit_id CHAR(36),
        lote_id CHAR(36),
        status VARCHAR(30) DEFAULT 'Disponível',
        data_validade DATE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela kits criada');
  } catch (error) {
    if (error.code === 'ER_TABLE_EXISTS_ERROR') {
      console.log('  ℹ Tabela kits já existe');
    } else {
      console.error(`  ✗ Erro ao criar tabela kits: ${error.message}`);
    }
  }
};
