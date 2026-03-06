const bcrypt = require('bcrypt');
const utilizadoresRepository = require('../repositories/utilizadores.repository');
const perfisRepository = require('../repositories/perfis.repository');
const empresasRepository = require('../repositories/empresas.repository');
const logService = require('./log.service');

exports.listAll = async (user) => {
    // Se for admin, pode ver todos os utilizadores da empresa
    if (user.empresa_id) {
        return await utilizadoresRepository.findByEmpresa(user.empresa_id);
    }
    return await utilizadoresRepository.findAll();
};

exports.getById = async (id, user) => {
    const utilizador = await utilizadoresRepository.findById(id);
    
    // Verificar permissões
    if (user.empresa_id && utilizador.empresa_id !== user.empresa_id) {
        throw new Error('Sem permissão para aceder a este utilizador');
    }
    
    return utilizador;
};

exports.create = async (data, user) => {
    // Validações
    if (!data.nome || data.nome.trim() === '') {
        throw new Error('Nome do utilizador é obrigatório');
    }

    if (!data.email || data.email.trim() === '') {
        throw new Error('Email é obrigatório');
    }

    if (!data.password || data.password.trim() === '') {
        throw new Error('Senha é obrigatória');
    }

    // Validar email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(data.email)) {
        throw new Error('Email inválido');
    }

    // Verificar se email já existe
    const existeEmail = await utilizadoresRepository.existeEmail(data.email);
    if (existeEmail) {
        throw new Error('Já existe um utilizador com este email');
    }

    // Validar perfil se fornecido
    if (data.perfil_id) {
        const perfil = await perfisRepository.findById(data.perfil_id);
        if (!perfil) {
            throw new Error('Perfil não encontrado');
        }
    }

    // Validar empresa se fornecida
    if (data.empresa_id) {
        const empresa = await empresasRepository.findById(data.empresa_id);
        if (!empresa) {
            throw new Error('Empresa não encontrada');
        }
    }

    // Validar telefone se fornecido
    if (data.telefone && data.telefone.trim() === '') {
        data.telefone = null;
    }

    // Hash da password
    const passwordHash = await bcrypt.hash(data.password, 10);

    const utilizador = await utilizadoresRepository.create({
        nome: data.nome.trim(),
        email: data.email.trim(),
        telefone: data.telefone ? data.telefone.trim() : null,
        perfil_id: data.perfil_id || null,
        empresa_id: data.empresa_id || null,
        password_hash: passwordHash,
        ativo: data.ativo !== undefined ? data.ativo : true
    });

    // Log da ação
    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou utilizador",
            tabela: "utilizadores",
            registro_id: utilizador.id
        });
    }

    // Remover password_hash da resposta
    const { password_hash, ...utilizadorSemPassword } = utilizador;
    return utilizadorSemPassword;
};

exports.update = async (id, data, user) => {
    // Verificar se existe
    const utilizador = await utilizadoresRepository.findById(id);
    if (!utilizador) {
        throw new Error('Utilizador não encontrado');
    }

    // Verificar permissões
    if (user.empresa_id && utilizador.empresa_id !== user.empresa_id) {
        throw new Error('Sem permissão para atualizar este utilizador');
    }

    // Validações
    if (data.nome !== undefined) {
        if (!data.nome || data.nome.trim() === '') {
            throw new Error('Nome do utilizador não pode estar vazio');
        }
    }

    if (data.email !== undefined) {
        if (!data.email || data.email.trim() === '') {
            throw new Error('Email não pode estar vazio');
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(data.email)) {
            throw new Error('Email inválido');
        }

        if (utilizador.email !== data.email) {
            const existeEmail = await utilizadoresRepository.existeEmail(data.email, id);
            if (existeEmail) {
                throw new Error('Já existe outro utilizador com este email');
            }
        }
    }

    if (data.perfil_id !== undefined && data.perfil_id !== null) {
        const perfil = await perfisRepository.findById(data.perfil_id);
        if (!perfil) {
            throw new Error('Perfil não encontrado');
        }
    }

    if (data.empresa_id !== undefined && data.empresa_id !== null) {
        const empresa = await empresasRepository.findById(data.empresa_id);
        if (!empresa) {
            throw new Error('Empresa não encontrada');
        }
    }

    // Hash da password se fornecida
    const updateData = {};
    if (data.nome !== undefined) updateData.nome = data.nome.trim();
    if (data.email !== undefined) updateData.email = data.email.trim();
    if (data.telefone !== undefined) updateData.telefone = data.telefone ? data.telefone.trim() : null;
    if (data.perfil_id !== undefined) updateData.perfil_id = data.perfil_id;
    if (data.empresa_id !== undefined) updateData.empresa_id = data.empresa_id;
    if (data.ativo !== undefined) updateData.ativo = data.ativo;
    
    if (data.password) {
        updateData.password_hash = await bcrypt.hash(data.password, 10);
    }

    await utilizadoresRepository.update(id, updateData);

    // Log da ação
    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou utilizador",
            tabela: "utilizadores",
            registro_id: id
        });
    }

    return { id, ...updateData };
};

exports.delete = async (id, user) => {
    // Verificar se existe
    const utilizador = await utilizadoresRepository.findById(id);
    if (!utilizador) {
        throw new Error('Utilizador não encontrado');
    }

    // Verificar permissões
    if (user.empresa_id && utilizador.empresa_id !== user.empresa_id) {
        throw new Error('Sem permissão para deletar este utilizador');
    }

    // Não permitir deletar a si próprio
    if (user.id === id) {
        throw new Error('Não pode deletar a sua própria conta');
    }

    await utilizadoresRepository.delete(id);

    // Log da ação
    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou utilizador",
            tabela: "utilizadores",
            registro_id: id
        });
    }

    return true;
};
