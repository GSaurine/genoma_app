const pool = require('../config/database');
const { getPaginationParams } = require('../utils/pagination');
const { v4: uuidv4 } = require('uuid');

exports.findAll = async (page, limit) => {
    const connection = await pool.getConnection();
    try {
        const { offset, limit: l } = getPaginationParams(page, limit);
        const [rows] = await connection.execute(
            'SELECT * FROM postos ORDER BY nome LIMIT ? OFFSET ?',
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
        const [rows] = await connection.execute('SELECT COUNT(*) as total FROM postos');
        return rows[0].total;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM postos WHERE id = ?', [id]);
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
            'INSERT INTO postos (id, entidade_id, nome, codigo_posto, localizacao) VALUES (?, ?, ?, ?, ?)',
            [id, data.entidade_id || null, data.nome, data.codigo_posto || null, data.localizacao || null]
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
        
        if (data.entidade_id !== undefined) {
            updates.push('entidade_id = ?');
            values.push(data.entidade_id);
        }
        if (data.nome !== undefined) {
            updates.push('nome = ?');
            values.push(data.nome);
        }
        if (data.codigo_posto !== undefined) {
            updates.push('codigo_posto = ?');
            values.push(data.codigo_posto);
        }
        if (data.localizacao !== undefined) {
            updates.push('localizacao = ?');
            values.push(data.localizacao);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE postos SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM postos WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.findByCodigo = async (codigo) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM postos WHERE codigo_posto = ?', [codigo]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};
