const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

exports.create = async (data) => {
    const connection = await pool.getConnection();
    try {
        const id = uuidv4();
        await connection.execute(
            'INSERT INTO facturacao (id, processo_id, preco_teste, numero_fatura, data_fatura, entidade_multibanco, referencia_multibanco, comissao) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [
                id,
                data.processo_id,
                data.preco_teste || 0,
                data.numero_fatura || null,
                data.data_fatura || null,
                data.entidade_multibanco || null,
                data.referencia_multibanco || null,
                data.comissao ? 1 : 0
            ]
        );
        return { id, ...data };
    } finally {
        connection.release();
    }
};

exports.findByProcessoId = async (processoId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM facturacao WHERE processo_id = ?', [processoId]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.update = async (id, data) => {
    const connection = await pool.getConnection();
    try {
        await connection.execute(
            'UPDATE facturacao SET preco_teste = ?, numero_fatura = ?, data_fatura = ?, entidade_multibanco = ?, referencia_multibanco = ?, comissao = ? WHERE id = ?',
            [
                data.preco_teste,
                data.numero_fatura,
                data.data_fatura,
                data.entidade_multibanco,
                data.referencia_multibanco,
                data.comissao ? 1 : 0,
                id
            ]
        );
        return { id, ...data };
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        await connection.execute('DELETE FROM facturacao WHERE id = ?', [id]);
    } finally {
        connection.release();
    }
};
