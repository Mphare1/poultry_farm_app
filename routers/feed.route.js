const express = require('express');
const { 
    createFeedRecord, 
    getFeedRecords, 
    updateFeedRecord, 
    deleteFeedRecord 
} = require('../controller/feed.controller');

const router = express.Router();

// Create a new feed record
router.post('/', createFeedRecord);

// Get all feed records for a specific farm
router.get('/:farm_id', getFeedRecords);

// Update a specific feed record
router.put('/:id', updateFeedRecord);

// Delete a specific feed record
router.delete('/:id', deleteFeedRecord);

module.exports = router;