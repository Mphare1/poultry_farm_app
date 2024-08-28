const Inventory = require('../models/inventory.model');

const createInventoryItem = async (req, res, next) => {
    try {
        const { farm_id, type, item, quantity, notes } = req.body;

        const newItem = new Inventory({
            farm_id,
            type,
            item,
            quantity,
            notes,
        });

        await newItem.save();
        res.status(201).json({ message: 'Inventory item created successfully' });
    } catch (error) {
        next(error);
    }
};

const getInventory = async (req, res, next) => {
    try {
        const inventory = await Inventory.find({ farm_id: req.params.farm_id });
        res.status(200).json(inventory);
    } catch (error) {
        next(error);
    }
};

const updateInventoryItem = async (req, res, next) => {
    try {
        const updatedItem = await Inventory.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedItem) return res.status(404).json({ message: 'Item not found' });
        res.status(200).json(updatedItem);
    } catch (error) {
        next(error);
    }
};

const deleteInventoryItem = async (req, res, next) => {
    try {
        const deletedItem = await Inventory.findByIdAndDelete(req.params.id);
        if (!deletedItem) return res.status(404).json({ message: 'Item not found' });
        res.status(200).json({ message: 'Item deleted successfully' });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    createInventoryItem,
    getInventory,
    updateInventoryItem,
    deleteInventoryItem
};
