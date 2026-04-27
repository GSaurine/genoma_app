module.exports.up = async (db) => {
  try {
    await db.execute(`
      CREATE TABLE IF NOT EXISTS facturacao (
        id CHAR(36) PRIMARY KEY,
        processo_id CHAR(36) NOT NULL,
        preco_teste DECIMAL(10,2) DEFAULT 0.00,
        numero_fatura VARCHAR(50),
        data_fatura DATE,
        entidade_multibanco VARCHAR(20),
        referencia_multibanco VARCHAR(20),
        comissao BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT fk_facturacao_processo FOREIGN KEY (processo_id) REFERENCES processos(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela facturacao criada');
  } catch (error) {
    console.log('  ℹ Tabela facturacao já existe ou erro: ' + (error && error.message));
  }
};
