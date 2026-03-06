const medicosRepository = require('../repositories/medicos.repository');
const utilizadoresRepository = require('../repositories/utilizadores.repository');
const logService = require('./log.service');

exports.listAll = async (user) => {
    return await medicosRepository.findAll();
};

exports.getById = async (utilizadorId, user) => {
    return await medicosRepository.findById(utilizadorId);
};

exports.create = async (data, user) => {
    // Validações
    if (!data.utilizador_id) {
        throw new Error('ID do utilizador é obrigatório');
    }

    if (!data.num_ordem || data.num_ordem.trim() === '') {
        throw new Error('Número de ordem é obrigatório');
    }

    // Verificar se utilizador existe
    const utilizador = await utilizadoresRepository.findById(data.utilizador_id);
    if (!utilizador) {
        throw new Error('Utilizador não encontrado');
    }

    // Verificar se utilizador já é médico
    const jaEhMedico = await medicosRepository.findById(data.utilizador_id);
    if (jaEhMedico) {
        throw new Error('Este utilizador já foi registado como médico');
    }

    // Verificar se número de ordem já existe
    const existenteNumOrdem = await medicosRepository.findByNumOrdem(data.num_ordem);
    if (existenteNumOrdem) {
        throw new Error('Já existe um médico com este número de ordem');
    }

    const medico = await medicosRepository.create({
        utilizador_id: data.utilizador_id,
        num_ordem: data.num_ordem.trim(),
        especialidade: data.especialidade ? data.especialidade.trim() : null
    });

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou médico",
            tabela: "medicos",
            registro_id: medico.utilizador_id
        });
    }

    return medico;
};

exports.update = async (utilizadorId, data, user) => {
    // Verificar se existe
    const medico = await medicosRepository.findById(utilizadorId);
    if (!medico) {
        throw new Error('Médico não encontrado');
    }

    // Validações
    if (data.num_ordem !== undefined) {
        if (!data.num_ordem || data.num_ordem.trim() === '') {
            throw new Error('Número de ordem não pode estar vazio');
        }

        if (medico.num_ordem !== data.num_ordem) {
            const existente = await medicosRepository.findByNumOrdem(data.num_ordem);
            if (existente) {
                throw new Error('Já existe outro médico com este número de ordem');
            }
        }
    }

    const updateData = {};
    if (data.num_ordem !== undefined) updateData.num_ordem = data.num_ordem.trim();
    if (data.especialidade !== undefined) updateData.especialidade = data.especialidade ? data.especialidade.trim() : null;

    await medicosRepository.update(utilizadorId, updateData);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou médico",
            tabela: "medicos",
            registro_id: utilizadorId
        });
    }

    return { utilizador_id: utilizadorId, ...updateData };
};

exports.delete = async (utilizadorId, user) => {
    // Verificar se existe
    const medico = await medicosRepository.findById(utilizadorId);
    if (!medico) {
        throw new Error('Médico não encontrado');
    }

    // Verificar se há pedidos associados
    const countPedidos = await medicosRepository.countPedidosAssociados(utilizadorId);
    if (countPedidos > 0) {
        throw new Error(`Não é possível remover este médico que tem ${countPedidos} pedido(s) de exame(s) associado(s)`);
    }

    await medicosRepository.delete(utilizadorId);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Removeu médico",
            tabela: "medicos",
            registro_id: utilizadorId
        });
    }

    return true;
};
