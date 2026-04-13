/**
 * Middleware de autorização por role (perfil).
 * Uso: requireRole('admin') ou requireRole(['admin','manager'])
 */
const requireRole = (required) => {
  const allowed = Array.isArray(required)
    ? required.map((r) => r.toString().toLowerCase())
    : [required.toString().toLowerCase()];

  return (req, res, next) => {
    if (!req.user) return res.status(401).json({ error: 'Token não fornecido' });

    // Token JWT inclui `role` (definido no login). Em alguns cenários
    // `req.user` pode conter `perfil_nome` (por compatibilidade).
    let role = '';
    if (typeof req.user.role === 'string') {
      role = req.user.role.toLowerCase();
    } else if (req.user.perfil_nome) {
      role = String(req.user.perfil_nome).toLowerCase();
    }

    if (!role || !allowed.includes(role)) {
      return res.status(403).json({ error: 'Acesso proibido' });
    }

    next();
  };
};

module.exports = { requireRole };
