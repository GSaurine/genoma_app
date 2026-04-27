const pool = require('../config/database');
const { getPaginationParams } = require('../utils/pagination');
const { v4: uuidv4 } = require('uuid');

exports.findAll = async (page, limit) => {
    const connection = await pool.getConnection();
    try {
        const { offset, limit: l } = getPaginationParams(page, limit);
        const [rows] = await connection.execute(
            `SELECT p.*, pac.nome as paciente_nome, med.num_ordem as medico_ordem, pos.nome as posto_nome, k.codigo_barras as kit_codigo 
             FROM processos p
             LEFT JOIN pacientes pac ON p.paciente_id = pac.id
             LEFT JOIN medicos med ON p.medico_id = med.utilizador_id
             LEFT JOIN postos pos ON p.posto_id = pos.id
             LEFT JOIN kits k ON p.kit_id = k.id
             ORDER BY p.data_entrada DESC LIMIT ${l} OFFSET ${offset}`
        );
        return rows;
    } finally {
        connection.release();
    }
};

exports.countAll = async () => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as total FROM processos');
        return rows[0].total;
    } finally {
        connection.release();
    }
};

exports.findById = async (id) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute(
            `SELECT p.*, pac.nome as paciente_nome, med.num_ordem as medico_ordem, pos.nome as posto_nome, k.codigo_barras as kit_codigo 
             FROM processos p
             LEFT JOIN pacientes pac ON p.paciente_id = pac.id
             LEFT JOIN medicos med ON p.medico_id = med.utilizador_id
             LEFT JOIN postos pos ON p.posto_id = pos.id
             LEFT JOIN kits k ON p.kit_id = k.id
             WHERE p.id = ?`, 
            [id]
        );
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
            'INSERT INTO processos (id, numero_processo, paciente_id, medico_id, posto_id, kit_id, status_id, notas) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [id, data.numero_processo, data.paciente_id || null, data.medico_id || null, data.posto_id || null, data.kit_id || null, data.status_id || 'Pendente', data.notas || null]
        );
        return {
            id,
            ...data,
            data_entrada: new Date()
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
        
        if (data.numero_processo !== undefined) {
            updates.push('numero_processo = ?');
            values.push(data.numero_processo);
        }
        if (data.paciente_id !== undefined) {
            updates.push('paciente_id = ?');
            values.push(data.paciente_id);
        }
        if (data.medico_id !== undefined) {
            updates.push('medico_id = ?');
            values.push(data.medico_id);
        }
        if (data.posto_id !== undefined) {
            updates.push('posto_id = ?');
            values.push(data.posto_id);
        }
        if (data.kit_id !== undefined) {
            updates.push('kit_id = ?');
            values.push(data.kit_id);
        }
        if (data.status_id !== undefined) {
            updates.push('status_id = ?');
            values.push(data.status_id);
        }
        if (data.notas !== undefined) {
            updates.push('notas = ?');
            values.push(data.notas);
        }
        
        if (updates.length === 0) return false;
        
        values.push(id);
        const query = `UPDATE processos SET ${updates.join(', ')} WHERE id = ?`;
        const result = await connection.execute(query, values);
        
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.delete = async (id) => {
    const connection = await pool.getConnection();
    try {
        const result = await connection.execute('DELETE FROM processos WHERE id = ?', [id]);
        return result[0].affectedRows > 0;
    } finally {
        connection.release();
    }
};

exports.findByNumero = async (numero) => {
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT * FROM processos WHERE numero_processo = ?', [numero]);
        return rows[0] || null;
    } finally {
        connection.release();
    }
};
