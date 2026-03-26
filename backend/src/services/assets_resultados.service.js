const assetsRepository = require('../repositories/assets_resultados.repository');
const logService = require('./log.service');

exports.getByProcessoId = async (processoId) => {
    return await assetsRepository.findByProcessoId(processoId);
};

exports.getById = async (id) => {
    const asset = await assetsRepository.findById(id);
    if (!asset) {
        throw new Error('Asset não encontrado');
    }
    return asset;
};

exports.create = async (data, user) => {
    if (!data.processo_id || !data.url_ficheiro) {
        throw new Error('Processo ID e URL do ficheiro são obrigatórios');
    }

    const asset = await assetsRepository.create(data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou asset de resultado",
            tabela: "assets_resultados",
            registro_id: asset.id
        });
    }

    return asset;
};

exports.update = async (id, data, user) => {
    const existing = await assetsRepository.findById(id);
    if (!existing) {
        throw new Error('Asset não encontrado');
    }

    await assetsRepository.update(id, data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou asset de resultado",
            tabela: "assets_resultados",
            registro_id: id
        });
    }

    return { id, ...data };
};

exports.delete = async (id, user) => {
    const existing = await assetsRepository.findById(id);
    if (!existing) {
        throw new Error('Asset não encontrado');
    }

    await assetsRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou asset de resultado",
            tabela: "assets_resultados",
            registro_id: id
        });
    }

    return true;
};
