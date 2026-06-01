const postosRepository = require('../repositories/postos.repository');
const logService = require('./log.service');

exports.listAll = async (page, limit) => {
    const postos = await postosRepository.findAll(page, limit);
    const total = await postosRepository.countAll();
    return { postos, total };
};

exports.getById = async (id) => {
    const posto = await postosRepository.findById(id);
    if (!posto) {
        throw new Error('Posto não encontrado');
    }
    return posto;
};

exports.create = async (data, user) => {
    if (!data.nome) {
        throw new Error('Nome do posto é obrigatório');
    }

    if (data.codigo_posto) {
        const existe = await postosRepository.findByCodigo(data.codigo_posto);
        if (existe) {
            throw new Error('Já existe um posto com este código');
        }
    }

    const posto = await postosRepository.create(data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou posto",
            tabela: "postos",
            registro_id: posto.id
        });
    }

    return posto;
};

exports.update = async (id, data, user) => {
    const existing = await postosRepository.findById(id);
    if (!existing) {
        throw new Error('Posto não encontrado');
    }

    if (data.codigo_posto && data.codigo_posto !== existing.codigo_posto) {
        const existe = await postosRepository.findByCodigo(data.codigo_posto);
        if (existe) {
            throw new Error('Já existe um posto com este código');
        }
    }

    await postosRepository.update(id, data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou posto",
            tabela: "postos",
            registro_id: id
        });
    }

    return { id, ...data };
};

exports.delete = async (id, user) => {
    const existing = await postosRepository.findById(id);
    if (!existing) {
        throw new Error('Posto não encontrado');
    }

    await postosRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou posto",
            tabela: "postos",
            registro_id: id
        });
    }

    return true;
};
