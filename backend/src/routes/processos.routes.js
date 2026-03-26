const express = require('express');
const router = express.Router();
const processosController = require('../controllers/processos.controller');
const authMiddleware = require('../middleware/auth.middleware');

router.get('/', authMiddleware, processosController.list);
router.get('/:id', authMiddleware, processosController.getById);
router.post('/', authMiddleware, processosController.create);
router.put('/:id', authMiddleware, processosController.update);
router.delete('/:id', authMiddleware, processosController.delete);

module.exports = router;
