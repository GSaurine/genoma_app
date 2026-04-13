const express = require('express');
const router = express.Router();

const empresasController = require('../controllers/empresas.controller');
const { authMiddleware, requireRole } = require('../middleware');

// GET /api/empresas - Listar todas as empresas
router.get('/', authMiddleware, empresasController.list);

// GET /api/empresas/:id - Obter uma empresa específica
router.get('/:id', authMiddleware, empresasController.getById);

// POST /api/empresas - Criar uma nova empresa
router.post('/', authMiddleware, requireRole('admin'), empresasController.create);

// PUT /api/empresas/:id - Atualizar uma empresa
router.put('/:id', authMiddleware, requireRole('admin'), empresasController.update);

// DELETE /api/empresas/:id - Deletar uma empresa
router.delete('/:id', authMiddleware, requireRole('admin'), empresasController.delete);

module.exports = router;
