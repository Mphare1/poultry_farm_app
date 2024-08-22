const Health = require('../models/health.model');

const createHealthRecord = async (req, res, next) => {
    try {
        const { farm_id, type, issue, treatment, notes } = req.body;

        const newRecord = new Health({
            farm_id,
            type,
            issue,
            treatment,
            notes,
        });

        await newRecord.save();
        res.status(201).json({ message: 'Health record created successfully' });
    } catch (error) {
        next(error);
    }
};

const getHealthRecords = async (req, res, next) => {
    try {
        const records = await Health.find({ farm_id: req.params.farm_id });
        res.status(200).json(records);
    } catch (error) {
        next(error);
    }
};

const updateHealthRecord = async (req, res, next) => {
    try {
        const updatedRecord = await Health.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedRecord) return res.status(404).json({ message: 'Record not found' });
        res.status(200).json(updatedRecord);
    } catch (error) {
        next(error);
    }
};

const deleteHealthRecord = async (req, res, next) => {
    try {
        const deletedRecord = await Health.findByIdAndDelete(req.params.id);
        if (!deletedRecord) return res.status(404).json({ message: 'Record not found' });
        res.status(200).json({ message: 'Record deleted successfully' });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    createHealthRecord,
    getHealthRecords,
    updateHealthRecord,
    deleteHealthRecord
};
