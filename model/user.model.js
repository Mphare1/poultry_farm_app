const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    role: {
        type: String,
        required: true,
    },
    farm_name: {  // Corrected field name
        type: String,
        // Make this field optional
        required: false,
    },
}, { timestamps: true });

const User = mongoose.model('User', userSchema);

module.exports = User;
