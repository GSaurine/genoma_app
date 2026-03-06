const logRepository = require('../repositories/log.repository');

exports.log = async ({ utilizador_id, acao, tabela }) => {
    await logRepository.create({
        utilizador_id,
        acao,
        tabela_afetada: tabela
    });
};