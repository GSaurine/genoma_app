/**
 * Índice centralizado de Repositories
 * Facilita importação de camada de dados
 */

const perfisRepository = require('./perfis.repository');
const empresasRepository = require('./empresas.repository');
const utilizadoresRepository = require('./utilizadores.repository');
const pacientesRepository = require('./pacientes.repository');
const testesRepository = require('./testes.repository');
const itensRepository = require('./itens_pesquisa.repository');
const medicosRepository = require('./medicos.repository');
const testeComposicaoRepository = require('./teste_composicao.repository');
const pedidosRepository = require('./pedidos_exames.repository');
const resultadosRepository = require('./resultados_detalhados.repository');
const postosRepository = require('./postos.repository');
const kitsRepository = require('./kits.repository');
const processosRepository = require('./processos.repository');
const resultadosGeneticosRepository = require('./resultados_geneticos.repository');
const assetsResultadosRepository = require('./assets_resultados.repository');

module.exports = {
  perfisRepository,
  empresasRepository,
  utilizadoresRepository,
  pacientesRepository,
  testesRepository,
  itensRepository,
  medicosRepository,
  testeComposicaoRepository,
  pedidosRepository,
  resultadosRepository,
  postosRepository,
  kitsRepository,
  processosRepository,
  resultadosGeneticosRepository,
  assetsResultadosRepository
};
