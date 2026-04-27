const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

exports.create = async (data) => {
    const connection = await pool.getConnection();
    try {
        const id = uuidv4();
        await connection.execute(
            'INSERT INTO informacao_clinica (id, processo_id, semanas_gravidez, dias_gravidez, tipo_gravidez, quer_saber_sexo, motivo_prescricao) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [id, data.processo_id, data.semanas_gravidez || null, data.dias_gravidez || null, data.tipo_gravidez || 'singular', data.quer_saber_sexo ? 1 : 0, data.motivo_prescricao || null]
        );
        return { id, ...data };
    } finally {
        connection.release();
    }
};

exports.findByProcessoId = async (processoId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM informacao_clinica WHERE processo_id = ?', [processoId]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};
