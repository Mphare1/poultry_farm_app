const express = require('express');
const {
    createInventoryItem,
    getInventory,
    updateInventoryItem,
    deleteInventoryItem
} = require('../controllers/inventory.controller');

const router = express.Router();

// Route to create a new inventory item
router.post('/', createInventoryItem);

// Route to get all inventory items for a farm
router.get('/:farm_id', getInventory);

// Route to update an inventory item by ID
router.put('/:id', updateInventoryItem);

// Route to delete an inventory item by ID
router.delete('/:id', deleteInventoryItem);

module.exports = router;
