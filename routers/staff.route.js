const express = require('express');
const {
    createStaffRecord,
    getStaffRecords,
    getStaffRecord,
    updateStaffRecord,
    deleteStaffRecord,
    assignWorkSchedule,
    generateSignUpCode
} = require('../controllers/staff.controller');

const router = express.Router();

// Route to create a new staff record
router.post('/', createStaffRecord);

// Route to get all staff records for a farm
router.get('/:farm_id', getStaffRecords);

// Route to get a single staff record by ID
router.get('/:id', getStaffRecord);

// Route to update a staff record by ID
router.put('/:id', updateStaffRecord);

// Route to delete a staff record by ID
router.delete('/:id', deleteStaffRecord);

// Route to assign work schedule to a staff member
router.post('/assign-schedule', assignWorkSchedule);

// Route to generate a sign-up code for new staff members
router.post('/generate-code', generateSignUpCode);

module.exports = router;
