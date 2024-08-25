// farm.model.js
const mongoose = require('mongoose');
const User = require('./user.model.js'); // Ensure the path is correct

const farmSchema = new mongoose.Schema({
    farm_name: { // Updated field name
        type: String,
        required: true
    },
    farm_code: { // Updated field name
        type: String,
        required: true,
        unique: true
    },
    owner: { // Reference to User who is the farm owner
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
}, { timestamps: true });

const Farm = mongoose.model('Farm', farmSchema);
module.exports = Farm;
