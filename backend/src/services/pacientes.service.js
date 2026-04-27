const pacientesRepository = require('../repositories/pacientes.repository');
const logService = require('./log.service');

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
    if (!data.nome || data.nome.trim() === '') {
        throw new Error('Nome do paciente é obrigatório');
    }

    if (!data.data_nascimento) {
        throw new Error('Data de nascimento é obrigatória');
    }

    // Validar data de nascimento
    const dataNasc = new Date(data.data_nascimento);
    const hoje = new Date();
    if (dataNasc >= hoje) {
        throw new Error('Data de nascimento inválida');
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

    const paciente = await pacientesRepository.create({
        nome: data.nome.trim(),
        data_nascimento: data.data_nascimento,
        genero: data.genero || null,
        nif: data.nif ? data.nif.trim() : null,
        telemovel: data.telemovel ? data.telemovel.trim() : null,
        email: data.email ? data.email.trim() : null,
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

    if (data.data_nascimento !== undefined) {
        const dataNasc = new Date(data.data_nascimento);
        const hoje = new Date();
        if (dataNasc >= hoje) {
            throw new Error('Data de nascimento inválida');
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
    if (data.data_nascimento !== undefined) updateData.data_nascimento = data.data_nascimento;
    if (data.genero !== undefined) updateData.genero = data.genero;
    if (data.nif !== undefined) updateData.nif = data.nif ? data.nif.trim() : null;
    if (data.telemovel !== undefined) updateData.telemovel = data.telemovel ? data.telemovel.trim() : null;
    if (data.email !== undefined) updateData.email = data.email ? data.email.trim() : null;
    if (data.morada !== undefined) updateData.morada = data.morada ? data.morada.trim() : null;
    if (data.altura !== undefined) updateData.altura = data.altura;
    if (data.peso !== undefined) updateData.peso = data.peso;

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