module.exports.up = async (db) => {
  try {
    const columns = await db.execute(`SHOW COLUMNS FROM pacientes`);
    const columnNames = columns[0].map(c => c.Field);

    if (!columnNames.includes('password_hash')) {
      await db.execute(`ALTER TABLE pacientes ADD COLUMN password_hash TEXT AFTER email`);
      console.log('  ✓ Campo password_hash adicionado à tabela pacientes');
    }
  } catch (error) {
    console.error(`  ✗ Erro ao adicionar campo password_hash em pacientes: ${error.message}`);
    throw error;
  }
};
