module.exports.up = async (db) => {
  try {
    const columns = await db.execute(`SHOW COLUMNS FROM pacientes`);
    const columnNames = columns[0].map(c => c.Field);

    if (!columnNames.includes('altura')) {
      await db.execute(`ALTER TABLE pacientes ADD COLUMN altura DECIMAL(5,2) AFTER morada`);
      console.log('  ✓ Campo altura adicionado à tabela pacientes');
    }
    
    if (!columnNames.includes('peso')) {
      await db.execute(`ALTER TABLE pacientes ADD COLUMN peso DECIMAL(5,2) AFTER altura`);
      console.log('  ✓ Campo peso adicionado à tabela pacientes');
    }
  } catch (error) {
    console.error(`  ✗ Erro ao adicionar campos altura e peso em pacientes: ${error.message}`);
    throw error;
  }
};
