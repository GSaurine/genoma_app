const processosService = require('../services/processos.service');

exports.list = async (req, res) => {
    try {
        const { page, limit } = req.query;
        const result = await processosService.listAll(page, limit);
        res.json({ data: result.processos, count: result.total });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const processo = await processosService.getById(req.params.id);
        res.json(processo);
    } catch (err) {
        res.status(err.message === 'Processo não encontrado' ? 404 : 500).json({ error: err.message });
    }
};

exports.create = async (req, res) => {
    try {
        const processo = await processosService.create(req.body, req.user);
        res.status(201).json({ message: 'Processo criado com sucesso', data: processo });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.update = async (req, res) => {
    try {
        const processo = await processosService.update(req.params.id, req.body, req.user);
        res.json({ message: 'Processo atualizado com sucesso', data: processo });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.delete = async (req, res) => {
    try {
        await processosService.delete(req.params.id, req.user);
        res.json({ message: 'Processo deletado com sucesso' });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};
