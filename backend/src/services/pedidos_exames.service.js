const pedidosRepository = require('../repositories/pedidos_exames.repository');
const pacientesRepository = require('../repositories/pacientes.repository');
const medicosRepository = require('../repositories/medicos.repository');
const testesRepository = require('../repositories/testes.repository');
const empresasRepository = require('../repositories/empresas.repository');
const logService = require('./log.service');

const STATUSES_VALIDOS = ['Pendente', 'Colhido', 'Em Análise', 'Concluído', 'Cancelado'];

exports.listAll = async (user) => {
    if (user.empresa_id) {
        return await pedidosRepository.findByEmpresa(user.empresa_id);
    }
    return await pedidosRepository.findAll();
};

exports.getById = async (id, user) => {
    const pedido = await pedidosRepository.findById(id);
    
    if (!pedido) {
        throw new Error('Pedido não encontrado');
    }

    // Verificar permissões
    if (user.empresa_id && pedido.empresa_id !== user.empresa_id) {
        throw new Error('Sem permissão para aceder a este pedido');
    }

    return pedido;
};

exports.listByPaciente = async (pacienteId, user) => {
    const paciente = await pacientesRepository.findById(pacienteId);
    if (!paciente) {
        throw new Error('Paciente não encontrado');
    }

    return await pedidosRepository.findByPaciente(pacienteId);
};

exports.create = async (data, user) => {
    // Validações
    if (!data.paciente_id || !data.medico_id || !data.teste_id || !data.empresa_id) {
        throw new Error('Paciente, médico, teste e empresa são obrigatórios');
    }

    // Verificar se paciente existe
    const paciente = await pacientesRepository.findById(data.paciente_id);
    if (!paciente) {
        throw new Error('Paciente não encontrado');
    }

    // Verificar se médico existe
    const medico = await medicosRepository.findById(data.medico_id);
    if (!medico) {
        throw new Error('Médico não encontrado');
    }

    // Verificar se teste existe
    const teste = await testesRepository.findById(data.teste_id);
    if (!teste) {
        throw new Error('Teste não encontrado');
    }

    // Verificar se empresa existe
    const empresa = await empresasRepository.findById(data.empresa_id);
    if (!empresa) {
        throw new Error('Empresa não encontrada');
    }

    // Validar status se fornecido
    if (data.status && !STATUSES_VALIDOS.includes(data.status)) {
        throw new Error(`Status inválido. Valores válidos: ${STATUSES_VALIDOS.join(', ')}`);
    }

    const pedido = await pedidosRepository.create({
        paciente_id: data.paciente_id,
        medico_id: data.medico_id,
        teste_id: data.teste_id,
        empresa_id: data.empresa_id,
        status: data.status || 'Pendente',
        notas_clinicas: data.notas_clinicas ? data.notas_clinicas.trim() : null
    });

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id || data.empresa_id,
            utilizador_id: user.id,
            acao: "Criou pedido de exame",
            tabela: "pedidos_exames",
            registro_id: pedido.id
        });
    }

    return pedido;
};

exports.update = async (id, data, user) => {
    // Verificar se existe
    const pedido = await pedidosRepository.findById(id);
    if (!pedido) {
        throw new Error('Pedido não encontrado');
    }

    // Verificar permissões
    if (user.empresa_id && pedido.empresa_id !== user.empresa_id) {
        throw new Error('Sem permissão para atualizar este pedido');
    }

    // Validar status se fornecido
    if (data.status && !STATUSES_VALIDOS.includes(data.status)) {
        throw new Error(`Status inválido. Valores válidos: ${STATUSES_VALIDOS.join(', ')}`);
    }

    const updateData = {};
    if (data.status !== undefined) updateData.status = data.status;
    if (data.notas_clinicas !== undefined) updateData.notas_clinicas = data.notas_clinicas ? data.notas_clinicas.trim() : null;

    await pedidosRepository.update(id, updateData);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id || pedido.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou pedido de exame",
            tabela: "pedidos_exames",
            registro_id: id
        });
    }

    return { id, ...updateData };
};

exports.delete = async (id, user) => {
    // Verificar se existe
    const pedido = await pedidosRepository.findById(id);
    if (!pedido) {
        throw new Error('Pedido não encontrado');
    }

    // Verificar permissões
    if (user.empresa_id && pedido.empresa_id !== user.empresa_id) {
        throw new Error('Sem permissão para deletar este pedido');
    }

    // Verificar se há resultados associados
    const countResultados = await pedidosRepository.countResultados(id);
    if (countResultados > 0) {
        throw new Error(`Não é possível deletar um pedido que tem ${countResultados} resultado(s) associado(s)`);
    }

    await pedidosRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id || pedido.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou pedido de exame",
            tabela: "pedidos_exames",
            registro_id: id
        });
    }

    return true;
};
