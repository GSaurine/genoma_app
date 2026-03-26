const express = require('express');
const router = express.Router();
const assetsController = require('../controllers/assets_resultados.controller');
const authMiddleware = require('../middleware/auth.middleware');

router.get('/processo/:processoId', authMiddleware, assetsController.getByProcessoId);
router.get('/:id', authMiddleware, assetsController.getById);
router.post('/', authMiddleware, assetsController.create);
router.put('/:id', authMiddleware, assetsController.update);
router.delete('/:id', authMiddleware, assetsController.delete);

module.exports = router;
