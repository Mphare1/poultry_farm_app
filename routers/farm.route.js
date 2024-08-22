const express = require('express');
const {
    createFarm,
    getFarms,
    getFarm,
    updateFarm,
    deleteFarm
} = require('../controllers/farm.controller');

const router = express.Router();

// Route to create a new farm
router.post('/', createFarm);

// Route to get all farms
router.get('/', getFarms);

// Route to get a single farm by ID
router.get('/:id', getFarm);

// Route to update a farm by ID
router.put('/:id', updateFarm);

// Route to delete a farm by ID
router.delete('/:id', deleteFarm);

module.exports = router;
