const pool = require('../config/database');
const { getPaginationParams } = require('../utils/pagination');
const { v4: uuidv4 } = require('uuid');

exports.findAll = async (page, limit) => {
    const connection = await pool.getConnection();
    try {
        const { offset, limit: l } = getPaginationParams(page, limit);
        const [rows] = await connection.execute(
            'SELECT * FROM kits ORDER BY data_validade DESC LIMIT ? OFFSET ?',
            [l, offset]
        );
        return rows;
    } finally {
        connection.release();
    }
};

exports.countAll = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as total FROM kits');
        return rows[0].total;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM kits WHERE id = ?', [id]);
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
            'INSERT INTO kits (id, codigo_barras, tipo_kit_id, lote_id, status, data_validade) VALUES (?, ?, ?, ?, ?, ?)',
            [id, data.codigo_barras, data.tipo_kit_id || null, data.lote_id || null, data.status || 'Disponível', data.data_validade || null]
        );
        return {
            id,
            ...data,
            status: data.status || 'Disponível'
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
        
        if (data.codigo_barras !== undefined) {
            updates.push('codigo_barras = ?');
            values.push(data.codigo_barras);
        }
        if (data.tipo_kit_id !== undefined) {
            updates.push('tipo_kit_id = ?');
            values.push(data.tipo_kit_id);
        }
        if (data.lote_id !== undefined) {
            updates.push('lote_id = ?');
            values.push(data.lote_id);
        }
        if (data.status !== undefined) {
            updates.push('status = ?');
            values.push(data.status);
        }
        if (data.data_validade !== undefined) {
            updates.push('data_validade = ?');
            values.push(data.data_validade);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE kits SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM kits WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.findByCodigoBarras = async (codigo) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM kits WHERE codigo_barras = ?', [codigo]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};
