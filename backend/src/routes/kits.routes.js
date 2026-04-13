const express = require('express');
const router = express.Router();
const kitsController = require('../controllers/kits.controller');
const { authMiddleware, requireRole } = require('../middleware');

router.get('/', authMiddleware, kitsController.list);
router.get('/:id', authMiddleware, kitsController.getById);
router.post('/', authMiddleware, requireRole('admin'), kitsController.create);
router.put('/:id', authMiddleware, requireRole('admin'), kitsController.update);
router.delete('/:id', authMiddleware, requireRole('admin'), kitsController.delete);

module.exports = router;
