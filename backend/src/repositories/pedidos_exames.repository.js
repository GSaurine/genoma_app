const pool = require('../config/database');

exports.findAll = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(`
            SELECT pe.id, pe.paciente_id, pe.medico_id, pe.teste_id, pe.empresa_id,
                   pe.data_pedido, pe.status, pe.notas_clinicas,
                   p.nome as paciente_nome, u.nome as medico_nome, t.nome as teste_nome,
                   e.nome as empresa_nome
            FROM pedidos_exames pe
            JOIN pacientes p ON pe.paciente_id = p.id
            JOIN medicos m ON pe.medico_id = m.utilizador_id
            JOIN utilizadores u ON m.utilizador_id = u.id
            JOIN testes t ON pe.teste_id = t.id
            JOIN empresas e ON pe.empresa_id = e.id
            ORDER BY pe.data_pedido DESC
        `);
        return rows;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(`
            SELECT pe.id, pe.paciente_id, pe.medico_id, pe.teste_id, pe.empresa_id,
                   pe.data_pedido, pe.status, pe.notas_clinicas,
                   p.nome as paciente_nome, u.nome as medico_nome, t.nome as teste_nome,
                   e.nome as empresa_nome
            FROM pedidos_exames pe
            JOIN pacientes p ON pe.paciente_id = p.id
            JOIN medicos m ON pe.medico_id = m.utilizador_id
            JOIN utilizadores u ON m.utilizador_id = u.id
            JOIN testes t ON pe.teste_id = t.id
            JOIN empresas e ON pe.empresa_id = e.id
            WHERE pe.id = ?
        `, [id]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};

exports.findByPaciente = async (pacienteId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(`
            SELECT pe.id, pe.paciente_id, pe.medico_id, pe.teste_id, pe.empresa_id,
                   pe.data_pedido, pe.status,
                   u.nome as medico_nome, t.nome as teste_nome
            FROM pedidos_exames pe
            JOIN medicos m ON pe.medico_id = m.utilizador_id
            JOIN utilizadores u ON m.utilizador_id = u.id
            JOIN testes t ON pe.teste_id = t.id
            WHERE pe.paciente_id = ?
            ORDER BY pe.data_pedido DESC
        `, [pacienteId]);
        return rows;
    } finally {
        connection.release();
    }
};

exports.findByEmpresa = async (empresaId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(`
            SELECT pe.id, pe.paciente_id, pe.medico_id, pe.teste_id,
                   pe.data_pedido, pe.status,
                   p.nome as paciente_nome, u.nome as medico_nome, t.nome as teste_nome
            FROM pedidos_exames pe
            JOIN pacientes p ON pe.paciente_id = p.id
            JOIN medicos m ON pe.medico_id = m.utilizador_id
            JOIN utilizadores u ON m.utilizador_id = u.id
            JOIN testes t ON pe.teste_id = t.id
            WHERE pe.empresa_id = ?
            ORDER BY pe.data_pedido DESC
        `, [empresaId]);
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
            'INSERT INTO pedidos_exames (id, paciente_id, medico_id, teste_id, empresa_id, status, notas_clinicas) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [
                id,
                data.paciente_id,
                data.medico_id,
                data.teste_id,
                data.empresa_id,
                data.status || 'Pendente',
                data.notas_clinicas || null
            ]
        );
        
        return {
            id,
            paciente_id: data.paciente_id,
            medico_id: data.medico_id,
            teste_id: data.teste_id,
            empresa_id: data.empresa_id,
            status: data.status || 'Pendente',
            notas_clinicas: data.notas_clinicas || null,
            data_pedido: new Date()
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
        
        if (data.status !== undefined) {
            updates.push('status = ?');
            values.push(data.status);
        }
        if (data.notas_clinicas !== undefined) {
            updates.push('notas_clinicas = ?');
            values.push(data.notas_clinicas);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE pedidos_exames SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM pedidos_exames WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.countResultados = async (pedidoId) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as count FROM resultados_detalhados WHERE pedido_id = ?', [pedidoId]);
        return rows[0].count;
    } finally {
        connection.release();
    }
};
