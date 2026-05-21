const kitsRepository = require('../repositories/kits.repository');
const lotesRepository = require('../repositories/lotes.repository');
const logService = require('./log.service');

exports.listAll = async (page, limit, filters = {}) => {
    const kits = await kitsRepository.findAll(page, limit, filters);
    const total = await kitsRepository.countAll(filters);
    return { kits, total };
};

exports.getById = async (id) => {
    const kit = await kitsRepository.findById(id);
    if (!kit) {
        throw new Error('Kit não encontrado');
    }
    return kit;
};

/**
 * Regra 1 e 2: Criar Lote e seus Kits
 */
exports.createLote = async (data, user) => {
    if (!data.numero_lote) throw new Error('Número do lote é obrigatório');
    if (!data.quantidade || data.quantidade <= 0) throw new Error('Quantidade de kits deve ser maior que zero');

    // 1. Criar o lote
    const lote = await lotesRepository.create({
        numero_lote: data.numero_lote,
        tipo_kit_id: data.tipo_kit_id,
        quantidade_inicial: data.quantidade
    });

    // 2. Gerar kits (Regra 2 e 3)
    const kitsParaCriar = [];
    for (let i = 1; i <= data.quantidade; i++) {
        // Exemplo de geração de número e tracking: LOTE-INDEX
        const numeroKit = `${data.numero_lote}-${String(i).padStart(4, '0')}`;
        kitsParaCriar.push({
            numero_kit: numeroKit,
            tracking: `TRK-${numeroKit}`,
            codigo_barras: `CB-${numeroKit}`, // Idealmente seria um input ou gerado de forma única
            tipo_kit_id: data.tipo_kit_id,
            lote_id: lote.id,
            empresa_id: user.empresa_id || data.empresa_id, // Regra 3: Gravados como estando na Empresa
            status: 'Na Empresa',
            data_validade: data.data_validade
        });
    }

    await kitsRepository.bulkCreate(kitsParaCriar);

    if (user) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Criou lote e kits",
            tabela: "lotes",
            registro_id: lote.id
        });
    }

    return { lote, quantidade_kits: kitsParaCriar.length };
};

/**
 * Regra 4: Enviar kits para postos de colheita
 */
exports.transferirParaPosto = async (data, user) => {
    if (!data.kit_ids || !Array.isArray(data.kit_ids) || data.kit_ids.length === 0) {
        throw new Error('Lista de IDs de kits é obrigatória');
    }
    if (!data.posto_id) throw new Error('ID do posto de destino é obrigatório');

    const afetados = await kitsRepository.transferirParaPosto(data.kit_ids, data.posto_id);

    if (user && afetados > 0) {
        await logService.log({
            empresa_id: user.empresa_id,
            utilizador_id: user.id,
            acao: "Transferiu kits para posto",
            tabela: "kits",
            registro_id: data.posto_id
        });
    }

    return { total_enviado: afetados };
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
