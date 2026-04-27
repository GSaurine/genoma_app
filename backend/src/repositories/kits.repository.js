const pool = require('../config/database');
const { getPaginationParams } = require('../utils/pagination');
const { v4: uuidv4 } = require('uuid');

exports.findAll = async (page, limit) => {
    const connection = await pool.getConnection();
    try {
        const { offset, limit: l } = getPaginationParams(page, limit);
        const [rows] = await connection.execute(
            `SELECT k.*, l.numero_lote, e.nome as empresa_nome, p.nome as posto_nome 
             FROM kits k
             LEFT JOIN lotes l ON k.lote_id = l.id
             LEFT JOIN empresas e ON k.empresa_id = e.id
             LEFT JOIN postos p ON k.posto_id = p.id
             ORDER BY k.data_validade DESC LIMIT ${l} OFFSET ${offset}`
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
        const query = `
            INSERT INTO kits (id, numero_kit, tracking, codigo_barras, tipo_kit_id, lote_id, empresa_id, posto_id, status, data_validade) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        const values = [
            id, 
            data.numero_kit || null,
            data.tracking || null,
            data.codigo_barras, 
            data.tipo_kit_id || null, 
            data.lote_id || null, 
            data.empresa_id || null,
            data.posto_id || null,
            data.status || 'Na Empresa', 
            data.data_validade || null
        ];
        
        await connection.execute(query, values);
        return {
            id,
            ...data,
            status: data.status || 'Na Empresa'
        };
    } finally {
        connection.release();
    }
};

exports.bulkCreate = async (kits) => {
    const connection = await pool.getConnection();
    try {
        const query = `
            INSERT INTO kits (id, numero_kit, tracking, codigo_barras, tipo_kit_id, lote_id, empresa_id, status, data_validade) 
            VALUES ?
        `;
        const values = kits.map(k => [
            uuidv4(),
            k.numero_kit,
            k.tracking,
            k.codigo_barras,
            k.tipo_kit_id,
            k.lote_id,
            k.empresa_id,
            k.status || 'Na Empresa',
            k.data_validade || null
        ]);
        
        await connection.query(query, [values]);
        return true;
    } finally {
        connection.release();
    }
};

exports.update = async (id, data) => {
    const connection = await pool.getConnection();
    try {
        const updates = [];
        const values = [];
        
        const fields = [
            'numero_kit', 'tracking', 'codigo_barras', 'tipo_kit_id', 
            'lote_id', 'empresa_id', 'posto_id', 'status', 'data_validade'
        ];

        fields.forEach(field => {
            if (data[field] !== undefined) {
                updates.push(`${field} = ?`);
                values.push(data[field]);
            }
        });
        
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

exports.transferirParaPosto = async (kitIds, postoId) => {
    const connection = await pool.getConnection();
    try {
        const query = `
            UPDATE kits 
            SET posto_id = ?, status = 'No Posto', empresa_id = NULL 
            WHERE id IN (${kitIds.map(() => '?').join(',')}) AND status = 'Na Empresa'
        `;
        const result = await connection.execute(query, [postoId, ...kitIds]);
        return result[0].affectedRows;
    } finally {
        connection.release();
    }
};
