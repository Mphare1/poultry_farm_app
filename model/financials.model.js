const mongoose = require('mongoose');
const Farm = require('./farm.model');

const financialsSchema = new mongoose.Schema({
    farm_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Farm', required: true },
    type: { type: String, enum: ['income', 'expense'], required: true },
    amount: { type: Number, required: true },
    description: { type: String },
    date: { type: Date, default: Date.now },
}, { timestamps: true });

const Financials = mongoose.model('Financials', financialsSchema);
module.exports = Financials;
