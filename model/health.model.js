const mongoose = require('mongoose');
const Farm = require('./farm.model');

const healthSchema = new mongoose.Schema({
    farm_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Farm', required: true },
    type: { type: String, enum: ['layer', 'broiler'], required: true },
    issue: { type: String, required: true },
    date: { type: Date, default: Date.now },
    treatment: { type: String },
    notes: { type: String },
}, { timestamps: true });

const Health = mongoose.model('Health', healthSchema);
module.exports = Health;
