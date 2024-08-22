const Feed = require('../models/feed.model');

const createFeedRecord = async (req, res, next) => {
    try {
        const { farm_id, type, feed_type, quantity, notes } = req.body;

        const newRecord = new Feed({
            farm_id,
            type,
            feed_type,
            quantity,
            notes,
        });

        await newRecord.save();
        res.status(201).json({ message: 'Feed record created successfully' });
    } catch (error) {
        next(error);
    }
};

const getFeedRecords = async (req, res, next) => {
    try {
        const records = await Feed.find({ farm_id: req.params.farm_id });
        res.status(200).json(records);
    } catch (error) {
        next(error);
    }
};

const updateFeedRecord = async (req, res, next) => {
    try {
        const updatedRecord = await Feed.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedRecord) return res.status(404).json({ message: 'Record not found' });
        res.status(200).json(updatedRecord);
    } catch (error) {
        next(error);
    }
};

const deleteFeedRecord = async (req, res, next) => {
    try {
        const deletedRecord = await Feed.findByIdAndDelete(req.params.id);
        if (!deletedRecord) return res.status(404).json({ message: 'Record not found' });
        res.status(200).json({ message: 'Record deleted successfully' });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    createFeedRecord,
    getFeedRecords,
    updateFeedRecord,
    deleteFeedRecord
};
