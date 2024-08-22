const mongoose = require('mongoose');
const User = require('./user.model');

const farmSchema = new mongoose.Schema({
    farmname: { type: String, required: true },
    farmcode: { type: String, required: true, unique: true },
    owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // reference to User who is the farm owner
}, { timestamps: true });

const Farm = mongoose.model('Farm', farmSchema);
module.exports = Farm;
