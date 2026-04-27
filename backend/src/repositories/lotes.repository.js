const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

exports.findAll = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM lotes ORDER BY data_criacao DESC');
        return rows;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM lotes WHERE id = ?', [id]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.create = async (data) => {
    const connection = await pool.getConnection();
    try {
        const id = uuidv4();
        await connection.execute(
            'INSERT INTO lotes (id, numero_lote, tipo_kit_id, quantidade_inicial) VALUES (?, ?, ?, ?)',
            [id, data.numero_lote, data.tipo_kit_id || null, data.quantidade_inicial || 0]
        );
        return { id, ...data };
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM lotes WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};
