const express = require('express');
const {
    createHealthRecord,
    getHealthRecords,
    updateHealthRecord,
    deleteHealthRecord
} = require('../controllers/health.controller');

const router = express.Router();

// Route to create a new health record
router.post('/', createHealthRecord);

// Route to get all health records for a farm
router.get('/:farm_id', getHealthRecords);

// Route to update a health record by ID
router.put('/:id', updateHealthRecord);

// Route to delete a health record by ID
router.delete('/:id', deleteHealthRecord);

module.exports = router;
