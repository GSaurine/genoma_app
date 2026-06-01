/**
 * Índice centralizado de middlewares
 * Facilita importação e manutenção
 */

const authMiddleware = require('./auth.middleware');
const { errorHandler, validationMiddleware, asyncHandler } = require('./error.middleware');
const { requireRole } = require('./role.middleware');

module.exports = {
  authMiddleware,
  requireRole,
  errorHandler,
  validationMiddleware,
  asyncHandler
};
