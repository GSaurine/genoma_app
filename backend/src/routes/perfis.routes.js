const express = require('express');
const router = express.Router();

const perfisController = require('../controllers/perfis.controller');
const authMiddleware = require('../middleware/auth.middleware');

// GET /api/perfis - Listar todos os perfis
router.get('/', authMiddleware, perfisController.list);

// GET /api/perfis/:id - Obter um perfil específico
router.get('/:id', authMiddleware, perfisController.getById);

// POST /api/perfis - Criar um novo perfil
router.post('/', authMiddleware, perfisController.create);

// PUT /api/perfis/:id - Atualizar um perfil
router.put('/:id', authMiddleware, perfisController.update);

// DELETE /api/perfis/:id - Deletar um perfil
router.delete('/:id', authMiddleware, perfisController.delete);

module.exports = router;
