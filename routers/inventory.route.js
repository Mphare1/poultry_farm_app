const express = require('express');
const {
    createInventoryItem,
    getInventory,
    updateInventoryItem,
    deleteInventoryItem
} = require('../controller/inventory.controller');

const router = express.Router();

// Route to create a new inventory item
router.post('/', createInventoryItem);

// Route to get all inventory items for a farm
router.get('/:farmId', getInventory); // Updated to match the parameter used in the controller

// Route to update an inventory item by ID
router.put('/:id', updateInventoryItem);

// Route to delete an inventory item by ID
router.delete('/:id', deleteInventoryItem);

module.exports = router;
