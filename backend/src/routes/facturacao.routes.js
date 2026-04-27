const express = require('express');
const router = express.Router();
const { facturacaoController } = require('../controllers');
const authMiddleware = require('../middleware/auth.middleware');

router.get('/processo/:processoId', authMiddleware, facturacaoController.getByProcessoId);
router.post('/', authMiddleware, facturacaoController.upsert);
router.delete('/:id', authMiddleware, facturacaoController.delete);

module.exports = router;
