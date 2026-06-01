const express = require('express');
const router = express.Router();
const resultadosController = require('../controllers/resultados_geneticos.controller');
const authMiddleware = require('../middleware/auth.middleware');

router.get('/processo/:processoId', authMiddleware, resultadosController.getByProcessoId);
router.get('/:id', authMiddleware, resultadosController.getById);
router.post('/', authMiddleware, resultadosController.create);
router.put('/:id', authMiddleware, resultadosController.update);
router.delete('/:id', authMiddleware, resultadosController.delete);

module.exports = router;
