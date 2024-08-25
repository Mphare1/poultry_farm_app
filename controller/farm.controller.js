const Farm = require('../models/farm.model');

const createFarm = async (req, res, next) => {
    try {
        const { farm_name, farm_code, owner } = req.body;

        if (!farm_name || !farm_code || !owner) {
            return res.status(400).json({ message: 'Farm name, code, and owner are required' });
        }

        const newFarm = new Farm({
            farm_name, // Ensure this matches the schema
            farm_code, // Ensure this matches the schema
            owner, // Ensure this matches the schema
        });

        await newFarm.save();
        res.status(201).json({ message: 'Farm created successfully', farm: newFarm });
    } catch (error) {
        next(error);
    }
};


const getFarms = async (req, res, next) => {
    try {
        // Populate 'owner' field instead of 'users'
        const farms = await Farm.find().populate('owner');
        res.status(200).json(farms);
    } catch (error) {
        next(error);
    }
};

const getFarm = async (req, res, next) => {
    try {
        // Populate 'owner' field instead of 'users'
        const farm = await Farm.findById(req.params.id).populate('owner');
        if (!farm) return res.status(404).json({ message: 'Farm not found' });
        res.status(200).json(farm);
    } catch (error) {
        next(error);
    }
};

const updateFarm = async (req, res, next) => {
    try {
        // Populate 'owner' field instead of 'users'
        const updatedFarm = await Farm.findByIdAndUpdate(req.params.id, req.body, { new: true }).populate('owner');
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
