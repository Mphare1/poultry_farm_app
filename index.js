const express = require('express');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const app = express();

const userRouter = require('./routers/user.route.js');
const authRouter = require('./routers/auth.route.js');
const staffRouter = require('./routers/staff.route.js');

dotenv.config(); // Load environment variables from .env file

// Connect to MongoDB
mongoose.connect(process.env.MONGO, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => {
    console.log('Database connection is successful');
}).catch((err) => {
    console.error('Database connection failed', err);
});

// Middleware to parse JSON bodies
app.use(express.json());

// Define routes
app.use('/api/user', userRouter);
app.use('/api/auth', authRouter);
app.use('/api/staff', staffRouter);

// Error handling middleware
app.use((err, req, res, next) => {
    const statusCode = err.statusCode || 500;
    const message = err.message || 'Internal server error';
    res.status(statusCode).json({
        success: false,
        statusCode,
        message,
    });
});

// Start the server
const port = process.env.PORT || 3000; // Use PORT from environment or default to 3000
app.listen(port, () => {
    console.log(`App running on port ${port}`);
});
