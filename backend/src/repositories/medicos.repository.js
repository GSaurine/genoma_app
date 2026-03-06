const pool = require('../config/database');

exports.findAll = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(`
            SELECT m.utilizador_id, m.num_ordem, m.especialidade,
                   u.nome, u.email, u.telefone, u.ativo
            FROM medicos m
            JOIN utilizadores u ON m.utilizador_id = u.id
            ORDER BY u.nome ASC
        `);
        return rows;
    } finally {
        connection.release();
    }
};

exports.findById = async (utilizadorId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(`
            SELECT m.utilizador_id, m.num_ordem, m.especialidade,
                   u.nome, u.email, u.telefone, u.ativo
            FROM medicos m
            JOIN utilizadores u ON m.utilizador_id = u.id
            WHERE m.utilizador_id = ?
        `, [utilizadorId]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.findByNumOrdem = async (numOrdem) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(`
            SELECT m.utilizador_id, m.num_ordem, m.especialidade,
                   u.nome, u.email
            FROM medicos m
            JOIN utilizadores u ON m.utilizador_id = u.id
            WHERE m.num_ordem = ?
        `, [numOrdem]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.create = async (data) => {
    const connection = await pool.getConnection();
    try {
        await connection.execute(
            'INSERT INTO medicos (utilizador_id, num_ordem, especialidade) VALUES (?, ?, ?)',
            [data.utilizador_id, data.num_ordem, data.especialidade || null]
        );
        
        return {
            utilizador_id: data.utilizador_id,
            num_ordem: data.num_ordem,
            especialidade: data.especialidade || null
        };
    } finally {
        connection.release();
    }
};

exports.update = async (utilizadorId, data) => {
    const connection = await pool.getConnection();
    try {
        const updates = [];
        const values = [];
        
        if (data.num_ordem !== undefined) {
            updates.push('num_ordem = ?');
            values.push(data.num_ordem);
        }
        if (data.especialidade !== undefined) {
            updates.push('especialidade = ?');
            values.push(data.especialidade);
        }
        
        if (updates.length === 0) return false;
        
        values.push(utilizadorId);
        const query = `UPDATE medicos SET ${updates.join(', ')} WHERE utilizador_id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (utilizadorId) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM medicos WHERE utilizador_id = ?', [utilizadorId]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.existeNumOrdem = async (numOrdem, excluirUtilizadorId = null) => {
    const connection = await pool.getConnection();
    try {
        let query = 'SELECT COUNT(*) as count FROM medicos WHERE num_ordem = ?';
        let params = [numOrdem];
        
        if (excluirUtilizadorId) {
            query += ' AND utilizador_id != ?';
            params.push(excluirUtilizadorId);
        }
        
        const [rows] = await connection.execute(query, params);
        return rows[0].count > 0;
    } finally {
        connection.release();
    }
};

exports.countPedidosAssociados = async (utilizadorId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as count FROM pedidos_exames WHERE medico_id = ?', [utilizadorId]);
        return rows[0].count;
    } finally {
        connection.release();
    }
};
