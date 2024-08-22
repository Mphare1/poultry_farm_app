const Financial = require('../models/financial.model');

const createFinancialRecord = async (req, res, next) => {
    try {
        const { farm_id, type, amount, description, date } = req.body;

        const newRecord = new Financial({
            farm_id,
            type,
            amount,
            description,
            date,
        });

        await newRecord.save();
        res.status(201).json({ message: 'Financial record created successfully' });
    } catch (error) {
        next(error);
    }
};

const getFinancialRecords = async (req, res, next) => {
    try {
        const records = await Financial.find({ farm_id: req.params.farm_id });
        res.status(200).json(records);
    } catch (error) {
        next(error);
    }
};

const updateFinancialRecord = async (req, res, next) => {
    try {
        const updatedRecord = await Financial.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedRecord) return res.status(404).json({ message: 'Record not found' });
        res.status(200).json(updatedRecord);
    } catch (error) {
        next(error);
    }
};

const deleteFinancialRecord = async (req, res, next) => {
    try {
        const deletedRecord = await Financial.findByIdAndDelete(req.params.id);
        if (!deletedRecord) return res.status(404).json({ message: 'Record not found' });
        res.status(200).json({ message: 'Record deleted successfully' });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    createFinancialRecord,
    getFinancialRecords,
    updateFinancialRecord,
    deleteFinancialRecord
};
