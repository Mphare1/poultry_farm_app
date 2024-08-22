const Farm = require('../models/farm.model');

const createFarm = async (req, res, next) => {
    try {
        const { name, code, location, type } = req.body;

        const newFarm = new Farm({
            name,
            code,
            location,
            type,
        });

        await newFarm.save();
        res.status(201).json({ message: 'Farm created successfully' });
    } catch (error) {
        next(error);
    }
};

const getFarms = async (req, res, next) => {
    try {
        const farms = await Farm.find().populate('users');
        res.status(200).json(farms);
    } catch (error) {
        next(error);
    }
};

const getFarm = async (req, res, next) => {
    try {
        const farm = await Farm.findById(req.params.id).populate('users');
        if (!farm) return res.status(404).json({ message: 'Farm not found' });
        res.status(200).json(farm);
    } catch (error) {
        next(error);
    }
};

const updateFarm = async (req, res, next) => {
    try {
        const updatedFarm = await Farm.findByIdAndUpdate(req.params.id, req.body, { new: true }).populate('users');
        if (!updatedFarm) return res.status(404).json({ message: 'Farm not found' });
        res.status(200).json(updatedFarm);
    } catch (error) {
        next(error);
    }
};

const deleteFarm = async (req, res, next) => {
    try {
        const deletedFarm = await Farm.findByIdAndDelete(req.params.id);
        if (!deletedFarm) return res.status(404).json({ message: 'Farm not found' });
        res.status(200).json({ message: 'Farm deleted successfully' });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    createFarm,
    getFarms,
    getFarm,
    updateFarm,
    deleteFarm
};
