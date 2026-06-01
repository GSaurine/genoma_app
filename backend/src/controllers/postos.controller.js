const postosService = require('../services/postos.service');

exports.list = async (req, res) => {
    try {
        const { page, limit } = req.query;
        const result = await postosService.listAll(page, limit);
        res.json({ data: result.postos, count: result.total });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const posto = await postosService.getById(req.params.id);
        res.json(posto);
    } catch (err) {
        res.status(err.message === 'Posto não encontrado' ? 404 : 500).json({ error: err.message });
    }
};

exports.create = async (req, res) => {
    try {
        const posto = await postosService.create(req.body, req.user);
        res.status(201).json({ message: 'Posto criado com sucesso', data: posto });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.update = async (req, res) => {
    try {
        const posto = await postosService.update(req.params.id, req.body, req.user);
        res.json({ message: 'Posto atualizado com sucesso', data: posto });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.delete = async (req, res) => {
    try {
        await postosService.delete(req.params.id, req.user);
        res.json({ message: 'Posto deletado com sucesso' });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};
