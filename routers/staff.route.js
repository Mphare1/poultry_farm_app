const express = require('express');
const router = express.Router();
const {
    createStaffRecord,
    getStaffRecords,
    getStaffRecord,
    updateStaffRecord,
    deleteStaffRecord,
    assignWorkSchedule,
    generateSignUpCode
} = require('../controller/staff.controller');

// Create a new staff record
router.post('/', createStaffRecord);

// Get all staff records for a specific farm
router.get('/:farm_id', getStaffRecords);

// Get a single staff record by ID
router.get('/record/:id', getStaffRecord);

// Update a staff record by ID
router.put('/:id', updateStaffRecord);

// Delete a staff record by ID
router.delete('/:id', deleteStaffRecord);

// Assign work schedule to a staff member
router.post('/assign-schedule', assignWorkSchedule);

// Generate a sign-up code
router.post('/generate-sign-up-code', generateSignUpCode);

module.exports = router;
