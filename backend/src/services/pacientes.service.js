const pacientesRepository = require('../repositories/pacientes.repository');
const logService = require('./log.service');
const bcrypt = require('bcrypt');

exports.listAll = async (user) => {
    return await pacientesRepository.findAll();
};

exports.getById = async (id, user) => {
    return await pacientesRepository.findById(id);
};

exports.search = async (nome, user) => {
    if (!nome || nome.trim() === '') {
        throw new Error('Nome é obrigatório para busca');
    }
    return await pacientesRepository.searchByNome(nome);
};

exports.create = async (data, user) => {
    // Validações
    console.log('DEBUG: Criando paciente com dados:', { ...data, password: data.password ? '******' : null });
    
    if (!data.nome || data.nome.trim() === '') {
        throw new Error('Nome do paciente é obrigatório');
    }

    if (!data.data_nascimento) {
        throw new Error('Data de nascimento é obrigatória');
    }

    // Normalizar e validar data de nascimento
    let data_nascimento = data.data_nascimento;
    if (typeof data_nascimento === 'string' && data_nascimento.includes('T')) {
        data_nascimento = data_nascimento.split('T')[0];
    }

    const dataNasc = new Date(data_nascimento);
    const hoje = new Date();
    hoje.setHours(23, 59, 59, 999); // Permitir datas de hoje

    if (isNaN(dataNasc.getTime())) {
        throw new Error('Formato de data de nascimento inválido');
    }

    if (dataNasc > hoje) {
        throw new Error('Data de nascimento não pode ser no futuro');
    }

    // Validar NIF se fornecido
    if (data.nif) {
        const existeNif = await pacientesRepository.existeNif(data.nif);
        if (existeNif) {
            throw new Error('Já existe um paciente com este NIF');
        }
    }

    // Validar email se fornecido
    if (data.email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(data.email)) {
            throw new Error('Email inválido');
        }
    }

    let password_hash = null;
    if (data.password) {
        password_hash = await bcrypt.hash(data.password, 10);
    }

    const paciente = await pacientesRepository.create({
        nome: data.nome.trim(),
        data_nascimento, // Usar data normalizada YYYY-MM-DD
        genero: data.genero || null,
        nif: data.nif ? data.nif.trim() : null,
        telemovel: data.telemovel ? data.telemovel.trim() : null,
        email: data.email ? data.email.trim() : null,
        password_hash,
        morada: data.morada ? data.morada.trim() : null,
        altura: data.altura || null,
        peso: data.peso || null
    });

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou paciente",
            tabela: "pacientes",
            registro_id: paciente.id
        });
    }

    return paciente;
};

exports.update = async (id, data, user) => {
    // Verificar se existe
    const paciente = await pacientesRepository.findById(id);
    if (!paciente) {
        throw new Error('Paciente não encontrado');
    }

    // Validações
    if (data.nome !== undefined) {
        if (!data.nome || data.nome.trim() === '') {
            throw new Error('Nome do paciente não pode estar vazio');
        }
    }

    let data_nascimento = data.data_nascimento;
    if (data.data_nascimento !== undefined) {
        if (typeof data_nascimento === 'string' && data_nascimento.includes('T')) {
            data_nascimento = data_nascimento.split('T')[0];
        }

        const dataNasc = new Date(data_nascimento);
        const hoje = new Date();
        hoje.setHours(23, 59, 59, 999);

        if (isNaN(dataNasc.getTime())) {
            throw new Error('Formato de data de nascimento inválido');
        }

        if (dataNasc > hoje) {
            throw new Error('Data de nascimento não pode ser no futuro');
        }
    }

    if (data.nif !== undefined && data.nif) {
        if (paciente.nif !== data.nif) {
            const existeNif = await pacientesRepository.existeNif(data.nif, id);
            if (existeNif) {
                throw new Error('Já existe outro paciente com este NIF');
            }
        }
    }

    if (data.email !== undefined && data.email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(data.email)) {
            throw new Error('Email inválido');
        }
    }

    const updateData = {};
    if (data.nome !== undefined) updateData.nome = data.nome.trim();
    if (data_nascimento !== undefined) updateData.data_nascimento = data_nascimento;
    if (data.genero !== undefined) updateData.genero = data.genero;
    if (data.nif !== undefined) updateData.nif = data.nif ? data.nif.trim() : null;
    if (data.telemovel !== undefined) updateData.telemovel = data.telemovel ? data.telemovel.trim() : null;
    if (data.email !== undefined) updateData.email = data.email ? data.email.trim() : null;
    if (data.morada !== undefined) updateData.morada = data.morada ? data.morada.trim() : null;
    if (data.altura !== undefined) updateData.altura = data.altura;
    if (data.peso !== undefined) updateData.peso = data.peso;

    if (data.password) {
        updateData.password_hash = await bcrypt.hash(data.password, 10);
    }

    await pacientesRepository.update(id, updateData);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou paciente",
            tabela: "pacientes",
            registro_id: id
        });
    }

    return { id, ...updateData };
};

exports.delete = async (id, user) => {
    // Verificar se existe
    const paciente = await pacientesRepository.findById(id);
    if (!paciente) {
        throw new Error('Paciente não encontrado');
    }

    // Verificar se há pedidos associados
    const pool = require('../config/database');
    const connection = await pool.getConnection();
    try {
        const [rows] = await connection.execute('SELECT COUNT(*) as count FROM pedidos_exames WHERE paciente_id = ?', [id]);
        if (rows[0].count > 0) {
            throw new Error(`Não é possível deletar um paciente que tem ${rows[0].count} pedido(s) de exame(s) associado(s)`);
        }
    } finally {
        connection.release();
    }

    await pacientesRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou paciente",
            tabela: "pacientes",
            registro_id: id
        });
    }

    return true;
};