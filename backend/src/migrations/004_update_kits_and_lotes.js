module.exports.up = async (db) => {
  try {
    // 1. Criar a tabela de lotes (Regra 1)
    await db.execute(`
      CREATE TABLE IF NOT EXISTS lotes (
        id CHAR(36) PRIMARY KEY,
        numero_lote VARCHAR(50) UNIQUE NOT NULL,
        tipo_kit_id CHAR(36),
        data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        quantidade_inicial INT DEFAULT 0
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela lotes criada');

    // 2. Adicionar os novos campos à tabela de kits (Regras 2, 3 e 4)
    // Usamos comandos individuais para garantir compatibilidade
    const columns = await db.execute(`SHOW COLUMNS FROM kits`);
    const columnNames = columns[0].map(c => c.Field);

    if (!columnNames.includes('numero_kit')) {
      await db.execute(`ALTER TABLE kits ADD COLUMN numero_kit VARCHAR(50) AFTER id`);
    }
    if (!columnNames.includes('tracking')) {
      await db.execute(`ALTER TABLE kits ADD COLUMN tracking VARCHAR(100) AFTER numero_kit`);
    }
    if (!columnNames.includes('empresa_id')) {
      await db.execute(`ALTER TABLE kits ADD COLUMN empresa_id CHAR(36) AFTER lote_id`);
    }
    if (!columnNames.includes('posto_id')) {
      await db.execute(`ALTER TABLE kits ADD COLUMN posto_id CHAR(36) AFTER empresa_id`);
    }
    
    // Atualizar o status para refletir a Regra 3
    await db.execute(`ALTER TABLE kits MODIFY COLUMN status VARCHAR(30) DEFAULT 'Na Empresa'`);

    // 3. Adicionar as Foreign Keys (tentar adicionar, ignorando se já existirem)
    try {
      await db.execute(`
        ALTER TABLE kits 
        ADD CONSTRAINT fk_kits_lote FOREIGN KEY (lote_id) REFERENCES lotes(id),
        ADD CONSTRAINT fk_kits_empresa FOREIGN KEY (empresa_id) REFERENCES empresas(id),
        ADD CONSTRAINT fk_kits_posto FOREIGN KEY (posto_id) REFERENCES postos(id)
      `);
      console.log('  ✓ Chaves estrangeiras adicionadas a kits');
    } catch (fkError) {
      console.log('  ℹ Chaves estrangeiras já existem ou erro ao adicionar: ' + fkError.message);
    }

    console.log('  ✓ Tabela kits atualizada com campos de Lote, Empresa e Posto');
  } catch (error) {
    console.error(`  ✗ Erro na migração de kits e lotes: ${error.message}`);
    throw error;
  }
};

module.exports.down = async (db) => {
  // Implementação opcional de rollback
};
