const { facturacaoRepository } = require('../repositories');

exports.getFacturacaoByProcessoId = async (processoId) => {
    return await facturacaoRepository.findByProcessoId(processoId);
};

exports.upsertFacturacao = async (data) => {
    const existing = await facturacaoRepository.findByProcessoId(data.processo_id);
    if (existing) {
        return await facturacaoRepository.update(existing.id, data);
    }
    return await facturacaoRepository.create(data);
};

exports.deleteFacturacao = async (id) => {
    return await facturacaoRepository.delete(id);
};
