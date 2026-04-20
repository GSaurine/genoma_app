const pool = require('../config/database');
const { getPaginationParams } = require('../utils/pagination');

exports.findAll = async (page, limit) => {
    const connection = await pool.getConnection();
    try {
        const { offset, limit: l } = getPaginationParams(page, limit);
        const [rows] = await connection.execute(
            `SELECT * FROM pacientes WHERE ativo = TRUE ORDER BY created_at DESC LIMIT ${l} OFFSET ${offset}`
        );
        return rows;
    } finally {
        connection.release();
    }
};

exports.countAll = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as total FROM pacientes WHERE ativo = TRUE');
        return rows[0].total;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM pacientes WHERE id = ? AND ativo = TRUE', [id]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.findByNif = async (nif) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM pacientes WHERE nif = ? AND ativo = TRUE', [nif]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.findByEmail = async (email) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM pacientes WHERE email = ? AND ativo = TRUE', [email]);
        return rows;
    } finally {
        connection.release();
    }
};

exports.searchByNome = async (nome, page, limit) => {
    const connection = await pool.getConnection();
    try {
        const { offset, limit: l } = getPaginationParams(page, limit);
        const [rows] = await connection.execute(
            `SELECT * FROM pacientes WHERE nome LIKE ? AND ativo = TRUE ORDER BY nome LIMIT ${l} OFFSET ${offset}`,
            [`%${nome}%`]
        );
        return rows;
    } finally {
        connection.release();
    }
};

exports.create = async (data) => {
    const connection = await pool.getConnection();
    try {
        const { v4: uuidv4 } = require('uuid');
        const id = uuidv4();
        await connection.execute(
            'INSERT INTO pacientes (id, nome, data_nascimento, genero, nif, telemovel, email, morada) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [id, data.nome, data.data_nascimento, data.genero || null, data.nif || null, data.telemovel || null, data.email || null, data.morada || null]
        );
        return {
            id,
            nome: data.nome,
            data_nascimento: data.data_nascimento,
            genero: data.genero || null,
            nif: data.nif || null,
            telemovel: data.telemovel || null,
            email: data.email || null,
            morada: data.morada || null,
            created_at: new Date()
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
        
        if (data.nome !== undefined) {
            updates.push('nome = ?');
            values.push(data.nome);
        }
        if (data.data_nascimento !== undefined) {
            updates.push('data_nascimento = ?');
            values.push(data.data_nascimento);
        }
        if (data.genero !== undefined) {
            updates.push('genero = ?');
            values.push(data.genero);
        }
        if (data.nif !== undefined) {
            updates.push('nif = ?');
            values.push(data.nif);
        }
        if (data.telemovel !== undefined) {
            updates.push('telemovel = ?');
            values.push(data.telemovel);
        }
        if (data.email !== undefined) {
            updates.push('email = ?');
            values.push(data.email);
        }
        if (data.morada !== undefined) {
            updates.push('morada = ?');
            values.push(data.morada);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE pacientes SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM pacientes WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.existeNif = async (nif, excluirId = null) => {
    const connection = await pool.getConnection();
    try {
        let query = 'SELECT COUNT(*) as count FROM pacientes WHERE nif = ?';
        let params = [nif];
        
        if (excluirId) {
            query += ' AND id != ?';
            params.push(excluirId);
        }
        
        const [rows] = await connection.execute(query, params);
        return rows[0].count > 0;
    } finally {
        connection.release();
    }
};

exports.countPacientes = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as count FROM pacientes');
        return rows[0].count;
    } finally {
        connection.release();
    }
};