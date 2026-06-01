const express = require('express');
const router = express.Router();
const processosController = require('../controllers/processos.controller');
const authMiddleware = require('../middleware/auth.middleware');

router.get('/', authMiddleware, processosController.list);

// GET /api/processos/paciente/:pacienteId - Listar processos de um paciente específico
router.get('/paciente/:pacienteId', authMiddleware, processosController.listByPaciente);

router.get('/:id', authMiddleware, processosController.getById);
router.post('/', authMiddleware, processosController.create);
router.put('/:id', authMiddleware, processosController.update);
router.delete('/:id', authMiddleware, processosController.delete);

module.exports = router;
