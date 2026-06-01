const express = require('express');
const router = express.Router();

const authRoutes = require('./auth.routes');
const perfisRoutes = require('./perfis.routes');
const empresasRoutes = require('./empresas.routes');
const utilizadoresRoutes = require('./utilizadores.routes');
const pacientesRoutes = require('./pacientes.routes');
const testesRoutes = require('./testes.routes');
const itensRoutes = require('./itens_pesquisa.routes');
const medicosRoutes = require('./medicos.routes');
const composicaoRoutes = require('./teste_composicao.routes');
const pedidosRoutes = require('./pedidos_exames.routes');
const resultadosRoutes = require('./resultados_detalhados.routes');
const postosRoutes = require('./postos.routes');
const kitsRoutes = require('./kits.routes');
const processosRoutes = require('./processos.routes');
const resultadosGeneticosRoutes = require('./resultados_geneticos.routes');
const assetsResultadosRoutes = require('./assets_resultados.routes');
const facturacaoRoutes = require('./facturacao.routes');

router.get('/ping', (req, res) => res.json({ success: true, message: 'pong', version: '1.0.1' }));

router.use('/auth', authRoutes);
router.use('/perfis', perfisRoutes);
router.use('/empresas', empresasRoutes);
router.use('/utilizadores', utilizadoresRoutes);
router.use('/pacientes', pacientesRoutes);
router.use('/testes', testesRoutes);
router.use('/itens', itensRoutes);
router.use('/medicos', medicosRoutes);
router.use('/teste-composicao', composicaoRoutes);
router.use('/pedidos', pedidosRoutes);
router.use('/resultados', resultadosRoutes);
router.use('/postos', postosRoutes);
router.use('/kits', kitsRoutes);
router.use('/processos', processosRoutes);
router.use('/resultados-geneticos', resultadosGeneticosRoutes);
router.use('/assets-resultados', assetsResultadosRoutes);
router.use('/facturacao', facturacaoRoutes);

module.exports = router;