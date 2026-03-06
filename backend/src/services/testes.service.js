const testesRepository = require('../repositories/testes.repository');
const logService = require('./log.service');

exports.listAll = async (user) => {
    return await testesRepository.findAll();
};

exports.getById = async (id, user) => {
    return await testesRepository.findById(id);
};

exports.create = async (data, user) => {
    // Validações
    if (!data.nome || data.nome.trim() === '') {
        throw new Error('Nome do teste é obrigatório');
    }

    // Verificar se já existe teste com o mesmo nome
    const existente = await testesRepository.findByNome(data.nome);
    if (existente) {
        throw new Error('Já existe um teste com este nome');
    }

    // Validar preço
    if (data.preco !== undefined) {
        if (isNaN(data.preco) || parseFloat(data.preco) < 0) {
            throw new Error('Preço deve ser um número positivo');
        }
    }

    const teste = await testesRepository.create({
        nome: data.nome.trim(),
        preco: data.preco ? parseFloat(data.preco) : 0.00,
        descricao: data.descricao ? data.descricao.trim() : null
    });

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou teste",
            tabela: "testes",
            registro_id: teste.id
        });
    }

    return teste;
};

exports.update = async (id, data, user) => {
    // Verificar se existe
    const teste = await testesRepository.findById(id);
    if (!teste) {
        throw new Error('Teste não encontrado');
    }

    // Validações
    if (data.nome !== undefined) {
        if (!data.nome || data.nome.trim() === '') {
            throw new Error('Nome do teste não pode estar vazio');
        }
        
        if (teste.nome !== data.nome) {
            const existente = await testesRepository.findByNome(data.nome);
            if (existente) {
                throw new Error('Já existe outro teste com este nome');
            }
        }
    }

    if (data.preco !== undefined) {
        if (isNaN(data.preco) || parseFloat(data.preco) < 0) {
            throw new Error('Preço deve ser um número positivo');
        }
    }

    const updateData = {};
    if (data.nome !== undefined) updateData.nome = data.nome.trim();
    if (data.preco !== undefined) updateData.preco = parseFloat(data.preco);
    if (data.descricao !== undefined) updateData.descricao = data.descricao ? data.descricao.trim() : null;

    await testesRepository.update(id, updateData);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Atualizou teste",
            tabela: "testes",
            registro_id: id
        });
    }

    return { id, ...updateData };
};

exports.delete = async (id, user) => {
    // Verificar se existe
    const teste = await testesRepository.findById(id);
    if (!teste) {
        throw new Error('Teste não encontrado');
    }

    // Verificar se tem itens de composição
    const countItens = await testesRepository.countItensComposicao(id);
    if (countItens > 0) {
        throw new Error(`Não é possível deletar um teste que tem ${countItens} item(ns) de composição associado(s)`);
    }

    // Verificar se tem pedidos associados
    const countPedidos = await testesRepository.countPedidosAssociados(id);
    if (countPedidos > 0) {
        throw new Error(`Não é possível deletar um teste que tem ${countPedidos} pedido(s) de exame(s) associado(s)`);
    }

    await testesRepository.delete(id);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Deletou teste",
            tabela: "testes",
            registro_id: id
        });
    }

    return true;
};
