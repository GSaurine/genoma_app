module.exports.up = async (db) => {
  try {
    // 1) Postos
    await db.execute(`
      CREATE TABLE IF NOT EXISTS postos (
        id CHAR(36) PRIMARY KEY,
        entidade_id CHAR(36),
        nome VARCHAR(100) NOT NULL,
        codigo_posto VARCHAR(20) UNIQUE,
        localizacao TEXT,
        KEY fk_entidade (entidade_id),
        CONSTRAINT fk_postos_empresas FOREIGN KEY (entidade_id) REFERENCES empresas(id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela postos criada');
  } catch (error) {
    console.log('  ℹ Tabela postos já existe ou erro: ' + (error && error.message));
  }

  try {
    // 2) Processos
    await db.execute(`
      CREATE TABLE IF NOT EXISTS processos (
        id CHAR(36) PRIMARY KEY,
        numero_processo VARCHAR(20) UNIQUE NOT NULL,
        paciente_id CHAR(36),
        medico_id CHAR(36),
        posto_id CHAR(36),
        kit_id CHAR(36),
        status_id VARCHAR(30),
        data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_processos_paciente FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
        CONSTRAINT fk_processos_medico FOREIGN KEY (medico_id) REFERENCES medicos(utilizador_id),
        CONSTRAINT fk_processos_posto FOREIGN KEY (posto_id) REFERENCES postos(id),
        CONSTRAINT fk_processos_kit FOREIGN KEY (kit_id) REFERENCES kits(id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela processos criada');
  } catch (error) {
    console.log('  ℹ Tabela processos já existe ou erro: ' + (error && error.message));
  }

  try {
    // 3) Resultados Genéticos
    await db.execute(`
      CREATE TABLE IF NOT EXISTS resultados_geneticos (
        id CHAR(36) PRIMARY KEY,
        processo_id CHAR(36),
        cromossoma VARCHAR(10),
        resultado_valor VARCHAR(50),
        probabilidade VARCHAR(50),
        tipo_resultado VARCHAR(20),
        CONSTRAINT fk_resultados_geneticos_processo FOREIGN KEY (processo_id) REFERENCES processos(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela resultados_geneticos criada');
  } catch (error) {
    console.log('  ℹ Tabela resultados_geneticos já existe ou erro: ' + (error && error.message));
  }

  try {
    // 4) Assets resultados
    await db.execute(`
      CREATE TABLE IF NOT EXISTS assets_resultados (
        id CHAR(36) PRIMARY KEY,
        processo_id CHAR(36),
        url_ficheiro TEXT NOT NULL,
        tipo_ficheiro VARCHAR(10) DEFAULT 'PDF',
        data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_assets_processo FOREIGN KEY (processo_id) REFERENCES processos(id)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    `);
    console.log('  ✓ Tabela assets_resultados criada');
  } catch (error) {
    console.log('  ℹ Tabela assets_resultados já existe ou erro: ' + (error && error.message));
  }
};
