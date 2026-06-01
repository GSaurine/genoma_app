/**
 * Índice centralizado de Services
 * Facilita importação de camada de negócio
 */

const authService = require('./auth.service');
const perfisService = require('./perfis.service');
const empresasService = require('./empresas.service');
const utilizadoresService = require('./utilizadores.service');
const pacientesService = require('./pacientes.service');
const testesService = require('./testes.service');
const itensService = require('./itens_pesquisa.service');
const medicosService = require('./medicos.service');
const testeComposicaoService = require('./teste_composicao.service');
const pedidosService = require('./pedidos_exames.service');
const resultadosService = require('./resultados_detalhados.service');
const postosService = require('./postos.service');
const kitsService = require('./kits.service');
const processosService = require('./processos.service');
const resultadosGeneticosService = require('./resultados_geneticos.service');
const assetsResultadosService = require('./assets_resultados.service');
const logService = require('./log.service');
const facturacaoService = require('./facturacao.service');

module.exports = {
  authService,
  perfisService,
  empresasService,
  utilizadoresService,
  pacientesService,
  testesService,
  itensService,
  medicosService,
  testeComposicaoService,
  pedidosService,
  resultadosService,
  postosService,
  kitsService,
  processosService,
  resultadosGeneticosService,
  assetsResultadosService,
  logService,
  facturacaoService
};
