const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'root',
    database: 'genoma'
});

connection.connect((err) => {
    if (err) {
        console.error('Erro ao conectar à base de dados:', err);
        return;
    }
    console.log('Conectado à base de dados MariaDB');
    createTables();
});

function createTables() {

    // PERFIS
    const createPerfisTable = `
        CREATE TABLE IF NOT EXISTS perfis (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            nome VARCHAR(50) NOT NULL UNIQUE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // EMPRESAS
    const createEmpresasTable = `
        CREATE TABLE IF NOT EXISTS empresas (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            nome VARCHAR(100) NOT NULL,
            morada TEXT,
            codigo_postal VARCHAR(20),
            telefone VARCHAR(20),
            email VARCHAR(100) UNIQUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // UTILIZADORES
    const createUtilizadoresTable = `
        CREATE TABLE IF NOT EXISTS utilizadores (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            perfil_id CHAR(36),
            empresa_id CHAR(36),
            nome VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            telefone VARCHAR(20),
            password_hash TEXT NOT NULL,
            ativo BOOLEAN DEFAULT TRUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

            FOREIGN KEY (perfil_id) REFERENCES perfis(id),
            FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // MEDICOS
    const createMedicosTable = `
        CREATE TABLE IF NOT EXISTS medicos (
            utilizador_id CHAR(36) PRIMARY KEY,
            num_ordem VARCHAR(20) UNIQUE NOT NULL,
            especialidade VARCHAR(100),

            FOREIGN KEY (utilizador_id) REFERENCES utilizadores(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // TESTES
    const createTestesTable = `
        CREATE TABLE IF NOT EXISTS testes (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            nome VARCHAR(100) NOT NULL,
            preco DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            descricao TEXT
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // ITENS PESQUISA
    const createItensPesquisaTable = `
        CREATE TABLE IF NOT EXISTS itens_pesquisa (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            codigo VARCHAR(10) NOT NULL UNIQUE,
            descricao VARCHAR(100) NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // TESTE_COMPOSICAO
    const createTesteComposicaoTable = `
        CREATE TABLE IF NOT EXISTS teste_composicao (
            teste_id CHAR(36),
            item_id CHAR(36),

            PRIMARY KEY (teste_id, item_id),
            FOREIGN KEY (teste_id) REFERENCES testes(id) ON DELETE CASCADE,
            FOREIGN KEY (item_id) REFERENCES itens_pesquisa(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // PACIENTES
    const createPacientesTable = `
        CREATE TABLE IF NOT EXISTS pacientes (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            nome VARCHAR(100) NOT NULL,
            data_nascimento DATE NOT NULL,
            genero VARCHAR(20),
            nif VARCHAR(20) UNIQUE,
            telemovel VARCHAR(20),
            email VARCHAR(100),
            morada TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // PEDIDOS_EXAMES
    const createPedidosTable = `
        CREATE TABLE IF NOT EXISTS pedidos_exames (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            paciente_id CHAR(36) NOT NULL,
            medico_id CHAR(36) NOT NULL,
            teste_id CHAR(36) NOT NULL,
            empresa_id CHAR(36) NOT NULL,
            data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            status VARCHAR(30) DEFAULT 'Pendente',
            notas_clinicas TEXT,

            FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
            FOREIGN KEY (medico_id) REFERENCES medicos(utilizador_id),
            FOREIGN KEY (teste_id) REFERENCES testes(id),
            FOREIGN KEY (empresa_id) REFERENCES empresas(id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // RESULTADOS
    const createResultadosTable = `
        CREATE TABLE IF NOT EXISTS resultados_detalhados (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            pedido_id CHAR(36) NOT NULL,
            item_id CHAR(36) NOT NULL,
            resultado VARCHAR(100),
            observacoes TEXT,
            data_resultado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

            FOREIGN KEY (pedido_id) REFERENCES pedidos_exames(id) ON DELETE CASCADE,
            FOREIGN KEY (item_id) REFERENCES itens_pesquisa(id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // POSTOS (11)
    const createPostosTable = `
        CREATE TABLE IF NOT EXISTS postos (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            entidade_id CHAR(36),
            nome VARCHAR(100) NOT NULL,
            codigo_posto VARCHAR(20) UNIQUE,
            localizacao TEXT,

            FOREIGN KEY (entidade_id) REFERENCES empresas(id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // KITS (12)
    const createKitsTable = `
        CREATE TABLE IF NOT EXISTS kits (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            codigo_barras VARCHAR(50) UNIQUE NOT NULL,
            tipo_kit_id CHAR(36),
            lote_id CHAR(36),
            status VARCHAR(30) DEFAULT 'Disponível',
            data_validade DATE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // PROCESSOS (13)
    const createProcessosTable = `
        CREATE TABLE IF NOT EXISTS processos (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            numero_processo VARCHAR(20) UNIQUE NOT NULL,
            paciente_id CHAR(36),
            medico_id CHAR(36),
            posto_id CHAR(36),
            kit_id CHAR(36),
            status_id VARCHAR(30),
            data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

            FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
            FOREIGN KEY (medico_id) REFERENCES medicos(utilizador_id),
            FOREIGN KEY (posto_id) REFERENCES postos(id),
            FOREIGN KEY (kit_id) REFERENCES kits(id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // RESULTADOS GENÉTICOS (14)
    const createResultadosGeneticosTable = `
        CREATE TABLE IF NOT EXISTS resultados_geneticos (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            processo_id CHAR(36),
            cromossoma VARCHAR(10),
            resultado_valor VARCHAR(50),
            probabilidade VARCHAR(50),
            tipo_resultado VARCHAR(20),

            FOREIGN KEY (processo_id) REFERENCES processos(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    // ASSETS (15)
    const createAssetsTable = `
        CREATE TABLE IF NOT EXISTS assets_resultados (
            id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
            processo_id CHAR(36),
            url_ficheiro TEXT NOT NULL,
            tipo_ficheiro VARCHAR(10) DEFAULT 'PDF',
            data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

            FOREIGN KEY (processo_id) REFERENCES processos(id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `;

    const tables = [
        createPerfisTable,
        createEmpresasTable,
        createUtilizadoresTable,
        createMedicosTable,
        createTestesTable,
        createItensPesquisaTable,
        createTesteComposicaoTable,
        createPacientesTable,
        createPedidosTable,
        createResultadosTable,
        createPostosTable,
        createKitsTable,
        createProcessosTable,
        createResultadosGeneticosTable,
        createAssetsTable
    ];

    tables.forEach((query, index) => {
        connection.query(query, (err) => {
            if (err) {
                console.error(`Erro ao criar tabela ${index + 1}:`, err);
            } else {
                console.log(`Tabela ${index + 1} criada ou já existe`);
            }

            if (index === tables.length - 1) {
                console.log('\n✅ Todas as tabelas foram criadas com sucesso!');
                connection.end();
            }
        });
    });
}