const express = require('express');
const router = express.Router();

const utilizadoresController = require('../controllers/utilizadores.controller');
const { authMiddleware, requireRole } = require('../middleware');

// GET /api/utilizadores - Listar todos os utilizadores
router.get('/', authMiddleware, requireRole('admin'), utilizadoresController.list);

// GET /api/utilizadores/:id - Obter um utilizador específico
router.get('/:id', authMiddleware, requireRole('admin'), utilizadoresController.getById);

// POST /api/utilizadores - Criar um novo utilizador
router.post('/', authMiddleware, requireRole('admin'), utilizadoresController.create);

// PUT /api/utilizadores/:id - Atualizar um utilizador
router.put('/:id', authMiddleware, requireRole('admin'), utilizadoresController.update);

// DELETE /api/utilizadores/:id - Deletar um utilizador
router.delete('/:id', authMiddleware, requireRole('admin'), utilizadoresController.delete);

module.exports = router;
