const bcrypt = require('bcrypt');
const { v4: uuidv4 } = require('uuid');

module.exports.up = async (db) => {
  try {
    // Verificar se o perfil admin já existe
    const [perfis] = await db.execute(
      `SELECT id FROM perfis WHERE nome = 'admin' LIMIT 1`
    );

    let adminRoleId;

    if (perfis.length === 0) {
      // Criar perfil admin
      adminRoleId = uuidv4();
      await db.execute(
        `INSERT INTO perfis (id, nome) VALUES (?, ?)`,
        [adminRoleId, 'admin']
      );
      console.log('  ✓ Perfil admin criado');
    } else {
      adminRoleId = perfis[0].id;
      console.log('  ℹ Perfil admin já existe');
    }

    // Verificar se o usuário admin já existe
    const [users] = await db.execute(
      `SELECT id FROM utilizadores WHERE email = 'admin@genoma.com' LIMIT 1`
    );

    if (users.length === 0) {
      // Criar usuário admin
      const adminId = uuidv4();
      const hashedPassword = await bcrypt.hash('admin123', 10);

      await db.execute(
        `INSERT INTO utilizadores (id, perfil_id, nome, email, password_hash, ativo) VALUES (?, ?, ?, ?, ?, ?)`,
        [adminId, adminRoleId, 'Administrador', 'admin@genoma.com', hashedPassword, true]
      );
      console.log('  ✓ Usuário admin criado (admin@genoma.com / admin123)');
    } else {
      console.log('  ℹ Usuário admin já existe');
    }
  } catch (error) {
    console.error('  ✗ Erro ao fazer seed de admin:', error.message);
  }
};
