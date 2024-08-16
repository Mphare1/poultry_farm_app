const mongoose = require('mongoose');

mongoose.connect('mongodb+srv://thipanemp:alxfinal@poultry-farm-app.gtcoj.mongodb.net/poultry-farm-app?retryWrites=true&w=majority&appName=poultry-farm-app').then(
    () => { console.log('Database connection is successful') },)