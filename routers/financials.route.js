const express = require('express');
const { 
    createFinancialRecord, 
    getFinancialRecords, 
    updateFinancialRecord, 
    deleteFinancialRecord 
} = require('../controllers/financial.controller');

const router = express.Router();

// Create a new financial record
router.post('/', createFinancialRecord);

// Get all financial records for a specific farm
router.get('/:farm_id', getFinancialRecords);

// Update a specific financial record
router.put('/:id', updateFinancialRecord);

// Delete a specific financial record
router.delete('/:id', deleteFinancialRecord);

module.exports = router;
