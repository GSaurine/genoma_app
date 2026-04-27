const { facturacaoService } = require('../services');

exports.getByProcessoId = async (req, res, next) => {
    try {
        const { processoId } = req.params;
        const facturacao = await facturacaoService.getFacturacaoByProcessoId(processoId);
        res.json(facturacao);
    } catch (error) {
        next(error);
    }
};

exports.upsert = async (req, res, next) => {
    try {
        const facturacao = await facturacaoService.upsertFacturacao(req.body);
        res.status(201).json(facturacao);
    } catch (error) {
        next(error);
    }
};

exports.delete = async (req, res, next) => {
    try {
        const { id } = req.params;
        await facturacaoService.deleteFacturacao(id);
        res.status(204).end();
    } catch (error) {
        next(error);
    }
};
