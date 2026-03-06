const pool = require('../config/database');

exports.findAll = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM testes ORDER BY nome ASC');
        return rows;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM testes WHERE id = ?', [id]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.findByNome = async (nome) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM testes WHERE nome = ?', [nome]);
        return rows[0] || null;
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
            'INSERT INTO testes (id, nome, preco, descricao) VALUES (?, ?, ?, ?)',
            [id, data.nome, data.preco || 0.00, data.descricao || null]
        );
        
        return {
            id,
            nome: data.nome,
            preco: data.preco || 0.00,
            descricao: data.descricao || null
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
        if (data.preco !== undefined) {
            updates.push('preco = ?');
            values.push(data.preco);
        }
        if (data.descricao !== undefined) {
            updates.push('descricao = ?');
            values.push(data.descricao);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE testes SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM testes WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.countItensComposicao = async (testeId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as count FROM teste_composicao WHERE teste_id = ?', [testeId]);
        return rows[0].count;
    } finally {
        connection.release();
    }
};

exports.countPedidosAssociados = async (testeId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as count FROM pedidos_exames WHERE teste_id = ?', [testeId]);
        return rows[0].count;
    } finally {
        connection.release();
    }
};
