const app = require('./app');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const userRoutes = require('./routers/user.route.js');

dotenv.config();

mongoose.connect(process.env.MONGO).then(
    () => { console.log('Database connection is successful') }).catch((err) => {
        console.error('Database connection failed', err)}
    );

const port = 3000;



app.listen(port, () => {
    console.log(`App running on port ${port}`);
    });

app.use('/test', (req, res) => {
    res.json({mesage:'API is working'});
});