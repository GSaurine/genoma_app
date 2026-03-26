const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

exports.findByProcessoId = async (processoId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(
            'SELECT * FROM resultados_geneticos WHERE processo_id = ?',
            [processoId]
        );
        return rows;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM resultados_geneticos WHERE id = ?', [id]);
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
            'INSERT INTO resultados_geneticos (id, processo_id, cromossoma, resultado_valor, probabilidade, tipo_resultado) VALUES (?, ?, ?, ?, ?, ?)',
            [id, data.processo_id, data.cromossoma || null, data.resultado_valor || null, data.probabilidade || null, data.tipo_resultado || null]
        );
        return {
            id,
            ...data
        };
    } finally {
        connection.release();
    }
};

exports.update = async (id, data) => {
    const connection = await pool.getConnection();
    try {
        const updates = [];
        const values = [];
        
        if (data.processo_id !== undefined) {
            updates.push('processo_id = ?');
            values.push(data.processo_id);
        }
        if (data.cromossoma !== undefined) {
            updates.push('cromossoma = ?');
            values.push(data.cromossoma);
        }
        if (data.resultado_valor !== undefined) {
            updates.push('resultado_valor = ?');
            values.push(data.resultado_valor);
        }
        if (data.probabilidade !== undefined) {
            updates.push('probabilidade = ?');
            values.push(data.probabilidade);
        }
        if (data.tipo_resultado !== undefined) {
            updates.push('tipo_resultado = ?');
            values.push(data.tipo_resultado);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE resultados_geneticos SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM resultados_geneticos WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};
