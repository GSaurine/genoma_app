const resultadosRepository = require('../repositories/resultados_geneticos.repository');
const logService = require('./log.service');

exports.getByProcessoId = async (processoId) => {
    return await resultadosRepository.findByProcessoId(processoId);
};

exports.getById = async (id) => {
    const resultado = await resultadosRepository.findById(id);
    if (!resultado) {
        throw new Error('Resultado genético não encontrado');
    }
    return resultado;
};

exports.create = async (data, user) => {
    if (!data.processo_id) {
        throw new Error('Processo ID é obrigatório');
    }

    const resultado = await resultadosRepository.create(data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou resultado genético",
            tabela: "resultados_geneticos",
            registro_id: resultado.id
        });
    }

    return resultado;
};

exports.update = async (id, data, user) => {
    const existing = await resultadosRepository.findById(id);
    if (!existing) {
        throw new Error('Resultado genético não encontrado');
    }

    await resultadosRepository.update(id, data);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou resultado genético",
            tabela: "resultados_geneticos",
            registro_id: id
        });
    }

    return { id, ...data };
};

exports.delete = async (id, user) => {
    const existing = await resultadosRepository.findById(id);
    if (!existing) {
        throw new Error('Resultado genético não encontrado');
    }

    await resultadosRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou resultado genético",
            tabela: "resultados_geneticos",
            registro_id: id
        });
    }

    return true;
};
