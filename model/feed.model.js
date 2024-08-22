const mongoose = require('mongoose');
const Farm = require('./farm.model');

const feedSchema = new mongoose.Schema({
    farm_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Farm', required: true },
    type: { type: String, enum: ['layer', 'broiler'], required: true },
    feed_type: { type: String, required: true },
    quantity: { type: Number, required: true },
    date: { type: Date, default: Date.now },
    notes: { type: String },
}, { timestamps: true });

const Feed = mongoose.model('Feed', feedSchema);
module.exports = Feed;
