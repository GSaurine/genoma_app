const pool = require('../config/database');
const { v4: uuidv4 } = require('uuid');

exports.findByProcessoId = async (processoId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(
            'SELECT * FROM assets_resultados WHERE processo_id = ?',
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
        const [rows] = await connection.execute('SELECT * FROM assets_resultados WHERE id = ?', [id]);
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
            'INSERT INTO assets_resultados (id, processo_id, url_ficheiro, tipo_ficheiro) VALUES (?, ?, ?, ?)',
            [id, data.processo_id, data.url_ficheiro, data.tipo_ficheiro || 'PDF']
        );
        return {
            id,
            ...data,
            data_upload: new Date()
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
        if (data.url_ficheiro !== undefined) {
            updates.push('url_ficheiro = ?');
            values.push(data.url_ficheiro);
        }
        if (data.tipo_ficheiro !== undefined) {
            updates.push('tipo_ficheiro = ?');
            values.push(data.tipo_ficheiro);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE assets_resultados SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM assets_resultados WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};
