const mongoose = require('mongoose');
const Farm = require('./farm.model');

const inventorySchema = new mongoose.Schema({
    farm: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Farm',
        required: true,
    },
    type: {
        type: String,
        enum: ['Layer', 'Broiler'],
        required: true,
    },
    quantity: {
        type: Number,
        required: true,
    },
    age: {
        type: Number, // in weeks or days, depending on what you prefer
        required: true,
    },
    feed: {
        type: Number, // in kilograms or any other measurement unit
        required: true,
    },
    healthStatus: {
        type: String,
        enum: ['Healthy', 'Sick', 'Deceased'],
        required: true,
    },
    // Additional fields for layers
    eggsCollected: {
        type: Number,
        required: function() { return this.type === 'Layer'; },
    },
    // Additional fields for broilers
    weight: {
        type: Number, // average weight per bird
        required: function() { return this.type === 'Broiler'; },
    },
}, { timestamps: true });

const Inventory = mongoose.model('Inventory', inventorySchema);

module.exports = Inventory;
