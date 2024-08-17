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
        required: false,
    },
    farmnname: {
        type: String,
        required: false,
    },
    farmcode: {
        type: String,
        required: false,
    },
}, { timestamps: true });

const User = mongoose.model('User', userSchema);

module.exports = User;