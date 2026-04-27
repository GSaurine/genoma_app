const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

exports.create = async (data) => {
    const connection = await pool.getConnection();
    try {
        const id = uuidv4();
        await connection.execute(
            'INSERT INTO colheitas (id, processo_id, posto_id, data_prevista, periodo, data_efetiva) VALUES (?, ?, ?, ?, ?, ?)',
            [id, data.processo_id, data.posto_id, data.data_prevista || null, data.periodo || null, data.data_efetiva || null]
        );
        return { id, ...data };
    } finally {
        connection.release();
    }
};

exports.findByProcessoId = async (processoId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM colheitas WHERE processo_id = ?', [processoId]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};
