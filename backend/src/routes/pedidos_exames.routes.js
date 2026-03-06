const express = require('express');
const router = express.Router();

const pedidosController = require('../controllers/pedidos_exames.controller');
const authMiddleware = require('../middleware/auth.middleware');

// GET /api/pedidos - Listar todos os pedidos
router.get('/', authMiddleware, pedidosController.list);

// GET /api/pedidos/:id - Obter um pedido específico
router.get('/:id', authMiddleware, pedidosController.getById);

// GET /api/pedidos/paciente/:pacienteId - Listar pedidos de um paciente
router.get('/paciente/:pacienteId', authMiddleware, pedidosController.listByPaciente);

// POST /api/pedidos - Criar um novo pedido
router.post('/', authMiddleware, pedidosController.create);

// PUT /api/pedidos/:id - Atualizar um pedido
router.put('/:id', authMiddleware, pedidosController.update);

// DELETE /api/pedidos/:id - Deletar um pedido
router.delete('/:id', authMiddleware, pedidosController.delete);

module.exports = router;
