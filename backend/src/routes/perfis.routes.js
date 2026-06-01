const express = require('express');
const router = express.Router();

const perfisController = require('../controllers/perfis.controller');
const { authMiddleware, requireRole } = require('../middleware');

// GET /api/perfis - Listar todos os perfis
router.get('/', authMiddleware, requireRole('admin'), perfisController.list);

// GET /api/perfis/:id - Obter um perfil específico
router.get('/:id', authMiddleware, requireRole('admin'), perfisController.getById);

// POST /api/perfis - Criar um novo perfil
router.post('/', authMiddleware, requireRole('admin'), perfisController.create);

// PUT /api/perfis/:id - Atualizar um perfil
router.put('/:id', authMiddleware, requireRole('admin'), perfisController.update);

// DELETE /api/perfis/:id - Deletar um perfil
router.delete('/:id', authMiddleware, requireRole('admin'), perfisController.delete);

module.exports = router;
