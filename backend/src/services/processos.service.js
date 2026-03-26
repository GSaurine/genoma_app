const processosRepository = require('../repositories/processos.repository');
const logService = require('./log.service');

exports.listAll = async (page, limit) => {
    const processos = await processosRepository.findAll(page, limit);
    const total = await processosRepository.countAll();
    return { processos, total };
};

exports.getById = async (id) => {
    const processo = await processosRepository.findById(id);
    if (!processo) {
        throw new Error('Processo não encontrado');
    }
    return processo;
};

exports.create = async (data, user) => {
    if (!data.numero_processo) {
        throw new Error('Número do processo é obrigatório');
    }

    const existe = await processosRepository.findByNumero(data.numero_processo);
    if (existe) {
        throw new Error('Já existe um processo com este número');
    }

    const processo = await processosRepository.create(data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou processo",
            tabela: "processos",
            registro_id: processo.id
        });
    }

    return processo;
};

exports.update = async (id, data, user) => {
    const existing = await processosRepository.findById(id);
    if (!existing) {
        throw new Error('Processo não encontrado');
    }

    if (data.numero_processo && data.numero_processo !== existing.numero_processo) {
        const existe = await processosRepository.findByNumero(data.numero_processo);
        if (existe) {
            throw new Error('Já existe um processo com este número');
        }
    }

    await processosRepository.update(id, data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou processo",
            tabela: "processos",
            registro_id: id
        });
    }

    return { id, ...data };
};

exports.delete = async (id, user) => {
    const existing = await processosRepository.findById(id);
    if (!existing) {
        throw new Error('Processo não encontrado');
    }

    await processosRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou processo",
            tabela: "processos",
            registro_id: id
        });
    }

    return true;
};
