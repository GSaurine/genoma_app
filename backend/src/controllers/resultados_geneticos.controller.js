const resultadosService = require('../services/resultados_geneticos.service');

exports.getByProcessoId = async (req, res) => {
    try {
        const resultados = await resultadosService.getByProcessoId(req.params.processoId);
        res.json(resultados);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const resultado = await resultadosService.getById(req.params.id);
        res.json(resultado);
    } catch (err) {
        res.status(err.message === 'Resultado genético não encontrado' ? 404 : 500).json({ error: err.message });
    }
};

exports.create = async (req, res) => {
    try {
        const resultado = await resultadosService.create(req.body, req.user);
        res.status(201).json({ message: 'Resultado genético criado com sucesso', data: resultado });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.update = async (req, res) => {
    try {
        const resultado = await resultadosService.update(req.params.id, req.body, req.user);
        res.json({ message: 'Resultado genético atualizado com sucesso', data: resultado });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

exports.delete = async (req, res) => {
    try {
        await resultadosService.delete(req.params.id, req.user);
        res.json({ message: 'Resultado genético deletado com sucesso' });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};
