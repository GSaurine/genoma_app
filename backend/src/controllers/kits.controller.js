const kitsService = require('../services/kits.service');

exports.list = async (req, res) => {
    try {
        const { page, limit } = req.query;
        const result = await kitsService.listAll(page, limit);
        res.json({ data: result.kits, count: result.total });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const kit = await kitsService.getById(req.params.id);
        res.json(kit);
    } catch (err) {
        res.status(err.message === 'Kit não encontrado' ? 404 : 500).json({ error: err.message });
    }
};

exports.create = async (req, res) => {
    try {
        const kit = await kitsService.create(req.body, req.user);
        res.status(201).json({ message: 'Kit criado com sucesso', data: kit });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.update = async (req, res) => {
    try {
        const kit = await kitsService.update(req.params.id, req.body, req.user);
        res.json({ message: 'Kit atualizado com sucesso', data: kit });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.delete = async (req, res) => {
    try {
        await kitsService.delete(req.params.id, req.user);
        res.json({ message: 'Kit deletado com sucesso' });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};
