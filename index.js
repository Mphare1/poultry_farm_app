const app = require('./app');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const userRouter = require('./routers/user.route.js');
const authRouter = require('./routers/auth.route.js');
const express = require('express');

dotenv.config();

mongoose.connect(process.env.MONGO).then(
    () => { console.log('Database connection is successful') }).catch((err) => {
        console.error('Database connection failed', err)}
    );

const port = 3000;
app.use(express.json());


app.listen(port, () => {
    console.log(`App running on port ${port}`);
    });

    app.use('/api/user', userRouter);
    app.use('/api/auth', authRouter);

    app.use((err, req, res, next) => {
        const statusCode = err.statusCode || 500;
        const message = err.message || 'Internal server error';
        res.status(statusCode).json({
            success: false,
            statusCode,
            message,
         });
        }
    );