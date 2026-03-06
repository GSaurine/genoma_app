module.exports.up = async (db) => {
  try {
    // Criar tabela perfis
    await db.execute(`
      CREATE TABLE IF NOT EXISTS perfis (
        id CHAR(36) PRIMARY KEY,
        nome VARCHAR(50) NOT NULL UNIQUE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela perfis criada');
  } catch (error) {
    console.log('  ℹ Tabela perfis já existe');
  }

  try {
    // Criar tabela empresas
    await db.execute(`
      CREATE TABLE IF NOT EXISTS empresas (
        id CHAR(36) PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        morada TEXT,
        codigo_postal VARCHAR(20),
        telefone VARCHAR(20),
        email VARCHAR(100) UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela empresas criada');
  } catch (error) {
    console.log('  ℹ Tabela empresas já existe');
  }

  try {
    // Criar tabela utilizadores
    await db.execute(`
      CREATE TABLE IF NOT EXISTS utilizadores (
        id CHAR(36) PRIMARY KEY,
        perfil_id CHAR(36),
        empresa_id CHAR(36),
        nome VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        telefone VARCHAR(20),
        password_hash TEXT NOT NULL,
        ativo BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        KEY fk_perfil (perfil_id),
        KEY fk_empresa (empresa_id),
        CONSTRAINT fk_utilizadores_perfis FOREIGN KEY (perfil_id) REFERENCES perfis(id),
        CONSTRAINT fk_utilizadores_empresas FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE SET NULL
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela utilizadores criada');
  } catch (error) {
    console.log('  ℹ Tabela utilizadores já existe');
  }

  try {
    // Criar tabela pacientes
    await db.execute(`
      CREATE TABLE IF NOT EXISTS pacientes (
        id CHAR(36) PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        data_nascimento DATE NOT NULL,
        genero VARCHAR(20),
        nif VARCHAR(20) UNIQUE,
        telemovel VARCHAR(20),
        email VARCHAR(100),
        morada TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela pacientes criada');
  } catch (error) {
    console.log('  ℹ Tabela pacientes já existe');
  }

  try {
    // Criar tabela testes
    await db.execute(`
      CREATE TABLE IF NOT EXISTS testes (
        id CHAR(36) PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        preco DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
        descricao TEXT
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela testes criada');
  } catch (error) {
    console.log('  ℹ Tabela testes já existe');
  }

  try {
    // Criar tabela itens_pesquisa
    await db.execute(`
      CREATE TABLE IF NOT EXISTS itens_pesquisa (
        id CHAR(36) PRIMARY KEY,
        codigo VARCHAR(10) NOT NULL UNIQUE,
        descricao VARCHAR(100) NOT NULL
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela itens_pesquisa criada');
  } catch (error) {
    console.log('  ℹ Tabela itens_pesquisa já existe');
  }

  try {
    // Criar tabela medicos
    await db.execute(`
      CREATE TABLE IF NOT EXISTS medicos (
        utilizador_id CHAR(36) PRIMARY KEY,
        num_ordem VARCHAR(20) UNIQUE NOT NULL,
        especialidade VARCHAR(100),
        CONSTRAINT fk_medicos_utilizadores FOREIGN KEY (utilizador_id) REFERENCES utilizadores(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela medicos criada');
  } catch (error) {
    console.log('  ℹ Tabela medicos já existe');
  }

  try {
    // Criar tabela teste_composicao
    await db.execute(`
      CREATE TABLE IF NOT EXISTS teste_composicao (
        teste_id CHAR(36),
        item_id CHAR(36),
        PRIMARY KEY (teste_id, item_id),
        CONSTRAINT fk_teste_composicao_testes FOREIGN KEY (teste_id) REFERENCES testes(id) ON DELETE CASCADE,
        CONSTRAINT fk_teste_composicao_itens FOREIGN KEY (item_id) REFERENCES itens_pesquisa(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela teste_composicao criada');
  } catch (error) {
    console.log('  ℹ Tabela teste_composicao já existe');
  }

  try {
    // Criar tabela pedidos_exames
    await db.execute(`
      CREATE TABLE IF NOT EXISTS pedidos_exames (
        id CHAR(36) PRIMARY KEY,
        paciente_id CHAR(36) NOT NULL,
        medico_id CHAR(36) NOT NULL,
        teste_id CHAR(36) NOT NULL,
        empresa_id CHAR(36) NOT NULL,
        data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status VARCHAR(30) DEFAULT 'Pendente',
        notas_clinicas TEXT,
        KEY fk_paciente (paciente_id),
        KEY fk_medico (medico_id),
        KEY fk_teste (teste_id),
        KEY fk_empresa (empresa_id),
        CONSTRAINT fk_pedidos_pacientes FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
        CONSTRAINT fk_pedidos_medicos FOREIGN KEY (medico_id) REFERENCES medicos(utilizador_id),
        CONSTRAINT fk_pedidos_testes FOREIGN KEY (teste_id) REFERENCES testes(id),
        CONSTRAINT fk_pedidos_empresas FOREIGN KEY (empresa_id) REFERENCES empresas(id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela pedidos_exames criada');
  } catch (error) {
    console.log('  ℹ Tabela pedidos_exames já existe');
  }

  try {
    // Criar tabela resultados_detalhados
    await db.execute(`
      CREATE TABLE IF NOT EXISTS resultados_detalhados (
        id CHAR(36) PRIMARY KEY,
        pedido_id CHAR(36) NOT NULL,
        item_id CHAR(36) NOT NULL,
        resultado VARCHAR(100),
        observacoes TEXT,
        data_resultado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        KEY fk_pedido (pedido_id),
        KEY fk_item (item_id),
        CONSTRAINT fk_resultados_pedidos FOREIGN KEY (pedido_id) REFERENCES pedidos_exames(id) ON DELETE CASCADE,
        CONSTRAINT fk_resultados_itens FOREIGN KEY (item_id) REFERENCES itens_pesquisa(id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela resultados_detalhados criada');
  } catch (error) {
    console.log('  ℹ Tabela resultados_detalhados já existe');
  }
};
