const Staff = require('../models/staff.model');
const errorHandling = require('../utils/error');

// Create a new staff record
const createStaffRecord = async (req, res, next) => {
    try {
        const staff = new Staff(req.body);
        const savedStaff = await staff.save();
        res.status(201).json(savedStaff);
    } catch (error) {
        next(error);
    }
};

// Get all staff records for a farm
const getStaffRecords = async (req, res, next) => {
    try {
        const { farm_id } = req.params;
        const staffRecords = await Staff.find({ farm: farm_id });
        res.status(200).json(staffRecords);
    } catch (error) {
        next(error);
    }
};

// Get a single staff record by ID
const getStaffRecord = async (req, res, next) => {
    try {
        const { id } = req.params;
        const staff = await Staff.findById(id);
        if (!staff) {
            return next(errorHandling(404, 'Staff member not found'));
        }
        res.status(200).json(staff);
    } catch (error) {
        next(error);
    }
};

// Update a staff record by ID
const updateStaffRecord = async (req, res, next) => {
    try {
        const { id } = req.params;
        const updatedStaff = await Staff.findByIdAndUpdate(id, req.body, { new: true });
        if (!updatedStaff) {
            return next(errorHandling(404, 'Staff member not found'));
        }
        res.status(200).json(updatedStaff);
    } catch (error) {
        next(error);
    }
};

// Delete a staff record by ID
const deleteStaffRecord = async (req, res, next) => {
    try {
        const { id } = req.params;
        const deletedStaff = await Staff.findByIdAndDelete(id);
        if (!deletedStaff) {
            return next(errorHandling(404, 'Staff member not found'));
        }
        res.status(200).json({ message: 'Staff member deleted successfully' });
    } catch (error) {
        next(error);
    }
};

// Assign work schedule to a staff member
const assignWorkSchedule = async (req, res, next) => {
    try {
        const { id, workDays, workHours } = req.body; // assuming the request contains staff ID, work days, and work hours
        const staff = await Staff.findById(id);
        if (!staff) {
            return next(errorHandling(404, 'Staff member not found'));
        }
        staff.workDays = workDays;
        staff.workHours = workHours;
        await staff.save();
        res.status(200).json({ message: 'Work schedule assigned successfully', staff });
    } catch (error) {
        next(error);
    }
};

// Generate a sign-up code for new staff members
const generateSignUpCode = async (req, res, next) => {
    try {
        const { farm_id } = req.body; // assuming the request contains the farm ID
        const code = Math.random().toString(36).substr(2, 8); // generate a simple random code
        // Here you can store the code in the database associated with the farm if needed
        res.status(200).json({ message: 'Sign-up code generated successfully', code });
    } catch (error) {
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
