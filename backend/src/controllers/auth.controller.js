const authService = require('../services/auth.service');

exports.register = async (req, res) => {
    try {
        const user = await authService.register(req.body);
        res.status(201).json(user);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.login = async (req, res) => {
    try {
        const token = await authService.login(req.body);
        res.json({ token });
    } catch (err) {
        res.status(401).json({ error: err.message });
    }
};

exports.loginPaciente = async (req, res) => {
    try {
        const token = await authService.loginPaciente(req.body);
        res.json({ token });
    } catch (err) {
        res.status(401).json({ error: err.message });
    }
};

exports.me = async (req, res) => {
    try {
        const user = await authService.getUserById(req.user.id);
        if (!user) {
            return res.status(404).json({ error: 'Utilizador não encontrado' });
        }
        res.json(user);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};