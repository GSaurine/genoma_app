const assetsService = require('../services/assets_resultados.service');

exports.getByProcessoId = async (req, res) => {
    try {
        const assets = await assetsService.getByProcessoId(req.params.processoId);
        res.json(assets);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const asset = await assetsService.getById(req.params.id);
        res.json(asset);
    } catch (err) {
        res.status(err.message === 'Asset não encontrado' ? 404 : 500).json({ error: err.message });
    }
};

exports.create = async (req, res) => {
    try {
        const asset = await assetsService.create(req.body, req.user);
        res.status(201).json({ message: 'Asset de resultado criado com sucesso', data: asset });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.update = async (req, res) => {
    try {
        const asset = await assetsService.update(req.params.id, req.body, req.user);
        res.json({ message: 'Asset de resultado atualizado com sucesso', data: asset });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.delete = async (req, res) => {
    try {
        await assetsService.delete(req.params.id, req.user);
        res.json({ message: 'Asset de resultado deletado com sucesso' });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};
