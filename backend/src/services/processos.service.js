const processosRepository = require('../repositories/processos.repository');
const informacaoClinicaRepository = require('../repositories/informacao_clinica.repository');
const colheitasRepository = require('../repositories/colheitas.repository');
const facturacaoRepository = require('../repositories/facturacao.repository');
const logService = require('./log.service');

exports.listAll = async (page, limit) => {
    const processos = await processosRepository.findAll(page, limit);
    const total = await processosRepository.countAll();
    return { processos, total };
};

exports.listByPacienteId = async (pacienteId) => {
    return await processosRepository.findByPacienteId(pacienteId);
};

exports.getById = async (id) => {
    const processo = await processosRepository.findById(id);
    if (!processo) {
        throw new Error('Processo não encontrado');
    }
    const infoClinica = await informacaoClinicaRepository.findByProcessoId(id);
    const colheita = await colheitasRepository.findByProcessoId(id);
    const facturacao = await facturacaoRepository.findByProcessoId(id);
    return { ...processo, informacao_clinica: infoClinica, colheita: colheita, facturacao: facturacao };
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

    // Salvar informação clínica se fornecida
    if (data.informacao_clinica) {
        await informacaoClinicaRepository.create({
            processo_id: processo.id,
            ...data.informacao_clinica
        });
    }

    // Salvar informação de colheita se fornecida
    if (data.colheita) {
        await colheitasRepository.create({
            processo_id: processo.id,
            ...data.colheita
        });
    }

    // Salvar informação de facturação se fornecida
    if (data.facturacao) {
        await facturacaoRepository.create({
            processo_id: processo.id,
            ...data.facturacao
        });
    }

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
