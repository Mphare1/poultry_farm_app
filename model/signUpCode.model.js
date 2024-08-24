const mongoose = require('mongoose');

const signUpCodeSchema = new mongoose.Schema({
    code: {
        type: String,
        required: true,
        unique: true,
    },
    role: {
        type: String,
        required: true,
    },
    suggestedUsername: {
        type: String,
        required: false,
    },
    expiresAt: {
        type: Date,
        required: true,
    },
}, { timestamps: true });

const SignUpCode = mongoose.model('SignUpCode', signUpCodeSchema);

module.exports = SignUpCode;
