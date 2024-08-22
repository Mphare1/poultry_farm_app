const mongoose = require('mongoose');
const Farm = require('./farm.model');

const staffSchema = new mongoose.Schema({
    farm_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Farm', required: true },
    user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    work_days: [{ type: String, enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'] }],
    work_hours: { start: { type: String }, end: { type: String } },
}, { timestamps: true });

const Staff = mongoose.model('Staff', staffSchema);
module.exports = Staff;
