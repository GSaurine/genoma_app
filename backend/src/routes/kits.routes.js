const express = require('express');
const router = express.Router();
const kitsController = require('../controllers/kits.controller');
const authMiddleware = require('../middleware/auth.middleware');

router.get('/', authMiddleware, kitsController.list);
router.get('/:id', authMiddleware, kitsController.getById);
router.post('/', authMiddleware, kitsController.create);
router.put('/:id', authMiddleware, kitsController.update);
router.delete('/:id', authMiddleware, kitsController.delete);

module.exports = router;
