const Staff = require('../model/staff.model'); // Import the Staff model
const Farm = require('../model/farm.model');  // Import the Farm model
const SignUpCode = require('../model/signUpCode.model'); 
const errorHandling = require("../utils/error.js");
const crypto = require('crypto');

// Create a new staff record
const createStaffRecord = async (req, res, next) => {
    const { name, role, farm_id } = req.body;

    if (!name || !role || !farm_id) {
        return next(errorHandling(400, 'All fields are required'));
    }

    try {
        const newStaff = new Staff({
            name,
            role,
            farm: farm_id,
        });

        await newStaff.save();
        res.status(201).json({ message: 'Staff record created successfully', staff: newStaff });
    } catch (error) {
        next(error);
    }
};


// Get all staff records for a specific farm
const getStaffRecords = async (req, res, next) => {
    const { farm_id } = req.params;

    // Log incoming request data
    console.log('Request to get staff records for farm:', farm_id);

    try {
        const staffRecords = await Staff.find({ farm: farm_id });
        res.status(200).json(staffRecords);
    } catch (error) {
        console.error('Error fetching staff records:', error);
        next(error);
    }
};

// Get a single staff record by ID
const getStaffRecord = async (req, res, next) => {
    const { id } = req.params;

    // Log incoming request data
    console.log('Request to get staff record by ID:', id);

    try {
        const staffRecord = await Staff.findById(id);
        if (!staffRecord) {
            return next(errorHandling(404, 'Staff record not found'));
        }
        res.status(200).json(staffRecord);
    } catch (error) {
        console.error('Error fetching staff record:', error);
        next(error);
    }
};

// Update a staff record by ID
const updateStaffRecord = async (req, res, next) => {
    const { id } = req.params;
    const { name, role } = req.body;

    // Log incoming request data
    console.log('Request to update staff record:', { id, name, role });

    try {
        const updatedStaff = await Staff.findByIdAndUpdate(
            id,
            { name, role },
            { new: true } // Return the updated document
        );

        if (!updatedStaff) {
            return next(errorHandling(404, 'Staff record not found'));
        }

        res.status(200).json({ message: 'Staff record updated successfully', staff: updatedStaff });
    } catch (error) {
        console.error('Error updating staff record:', error);
        next(error);
    }
};

// Delete a staff record by ID
const deleteStaffRecord = async (req, res, next) => {
    const { id } = req.params;

    // Log incoming request data
    console.log('Request to delete staff record by ID:', id);

    try {
        const deletedStaff = await Staff.findByIdAndDelete(id);

        if (!deletedStaff) {
            return next(errorHandling(404, 'Staff record not found'));
        }

        res.status(200).json({ message: 'Staff record deleted successfully' });
    } catch (error) {
        console.error('Error deleting staff record:', error);
        next(error);
    }
};

// Assign work schedule to a staff member
const assignWorkSchedule = async (req, res, next) => {
    const { id, workDays, workHours } = req.body;

    // Log incoming request data
    console.log('Request to assign work schedule:', { id, workDays, workHours });

    try {
        const staffRecord = await Staff.findById(id);

        if (!staffRecord) {
            return next(errorHandling(404, 'Staff record not found'));
        }

        staffRecord.workSchedule = { workDays, workHours };
        await staffRecord.save();

        res.status(200).json({ message: 'Work schedule assigned successfully', staff: staffRecord });
    } catch (error) {
        console.error('Error assigning work schedule:', error);
        next(error);
    }
};

// Generate a sign-up code for new staff members
const generateSignUpCode = async (req, res, next) => {
    const { role, suggestedUsername } = req.body;

    // Log incoming request data
    console.log('Request to generate sign-up code for staff:', req.body);

    try {
        // Generate a unique code
        const code = crypto.randomBytes(6).toString('hex');

        // Set expiration time (e.g., 24 hours from now)
        const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000);

        const newCode = new SignUpCode({
            code,
            role,
            suggestedUsername,
            expiresAt,
        });

        await newCode.save();

        res.status(201).json({ message: 'Sign-up code generated successfully', code });
    } catch (error) {
        console.error('Error generating sign-up code for staff:', error);
        next(error);
    }
};

module.exports = {
    createStaffRecord,
    getStaffRecords,
    getStaffRecord,
    updateStaffRecord,
    deleteStaffRecord,
    assignWorkSchedule,
    generateSignUpCode,
};
