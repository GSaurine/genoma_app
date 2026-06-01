module.exports.up = async (db) => {
  try {
    const columns = await db.execute(`SHOW COLUMNS FROM processos`);
    const columnNames = columns[0].map(c => c.Field);

    if (!columnNames.includes('notas')) {
      await db.execute(`ALTER TABLE processos ADD COLUMN notas TEXT AFTER data_entrada`);
      console.log('  ✓ Campo notas adicionado à tabela processos');
    }
  } catch (error) {
    console.error(`  ✗ Erro ao adicionar campo notas em processos: ${error.message}`);
    throw error;
  }
};
