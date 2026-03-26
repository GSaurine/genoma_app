const kitsRepository = require('../repositories/kits.repository');
const logService = require('./log.service');

exports.listAll = async (page, limit) => {
    const kits = await kitsRepository.findAll(page, limit);
    const total = await kitsRepository.countAll();
    return { kits, total };
};

exports.getById = async (id) => {
    const kit = await kitsRepository.findById(id);
    if (!kit) {
        throw new Error('Kit não encontrado');
    }
    return kit;
};

exports.create = async (data, user) => {
    if (!data.codigo_barras) {
        throw new Error('Código de barras do kit é obrigatório');
    }

    const existe = await kitsRepository.findByCodigoBarras(data.codigo_barras);
    if (existe) {
        throw new Error('Já existe um kit com este código de barras');
    }

    const kit = await kitsRepository.create(data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou kit",
            tabela: "kits",
            registro_id: kit.id
        });
    }

    return kit;
};

exports.update = async (id, data, user) => {
    const existing = await kitsRepository.findById(id);
    if (!existing) {
        throw new Error('Kit não encontrado');
    }

    if (data.codigo_barras && data.codigo_barras !== existing.codigo_barras) {
        const existe = await kitsRepository.findByCodigoBarras(data.codigo_barras);
        if (existe) {
            throw new Error('Já existe um kit com este código de barras');
        }
    }

    await kitsRepository.update(id, data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou kit",
            tabela: "kits",
            registro_id: id
        });
    }

    return { id, ...data };
};

exports.delete = async (id, user) => {
    const existing = await kitsRepository.findById(id);
    if (!existing) {
        throw new Error('Kit não encontrado');
    }

    await kitsRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou kit",
            tabela: "kits",
            registro_id: id
        });
    }

    return true;
};
