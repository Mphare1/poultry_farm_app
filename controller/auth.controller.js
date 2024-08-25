const User = require("../model/user.model.js");
const Farm = require("../model/farm.model.js");  // Import the Farm model
const SignUpCode = require('../model/signUpCode.model.js');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const errorHandling = require("../utils/error.js");
const crypto = require('crypto');

// Function to generate a one-time sign-up code
const generateSignUpCode = async (req, res, next) => {
    try {
        const { role, suggestedUsername } = req.body;

        // Generate a unique code
        const code = crypto.randomBytes(6).toString('hex');

        // Set expiration time (e.g., 24 hours from now)
        const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000);

        const newCode = new SignUpCode({
            code,
            role,
            suggestedUsername,
            expiresAt,
        });

        await newCode.save();

        res.status(201).json({ message: 'Sign-up code generated successfully', code });
    } catch (error) {
        next(error);
    }
};

// Sign-up function using a one-time code
const signupWithCode = async (req, res, next) => {
    const { code, email, password, farm_id } = req.body;

    if (!code || !email || !password || !farm_id) {
        return next(errorHandling(400, 'All fields are required'));
    }

    try {
        // Find the sign-up code in the database
        const signUpCode = await SignUpCode.findOne({ code });

        if (!signUpCode || new Date() > signUpCode.expiresAt) {
            return next(errorHandling(400, 'Invalid or expired sign-up code'));
        }

        const hashPassword = bcrypt.hashSync(password, 10);

        const newUser = new User({
            username: signUpCode.suggestedUsername || email.split('@')[0],
            email,
            password: hashPassword,
            role: signUpCode.role,
            farm: farm_id,
        });

        await newUser.save();

        // Remove the used sign-up code
        await SignUpCode.findByIdAndDelete(signUpCode._id);

        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        next(error);
    }
};

// Standard sign-up function with farm creation for owners/managers
const signup = async (req, res, next) => {
    const { username, email, password, role, farm_name } = req.body;

    if (!username || !email || !password || !role) {
        return next(errorHandling(400, 'All fields are required'));
    }

    try {
        // Create the user first
        const hashPassword = bcrypt.hashSync(password, 10);
        const newUser = new User({
            username,
            email,
            password: hashPassword,
            role,
            farm_name: role === 'owner' || role === 'manager' ? farm_name : null,
        });

        const savedUser = await newUser.save();

        // Create the farm if the role is 'owner' or 'manager'
        if (role === 'owner' || role === 'manager') {
            if (!farm_name) {
                return next(errorHandling(400, 'Farm name is required for owners or managers'));
            }

            const newFarm = new Farm({
                farm_name,
                farm_code: crypto.randomBytes(4).toString('hex'), // Generate a unique farm code
                owner: savedUser._id, // Use the saved user's ObjectId
            });

            await newFarm.save();
        }

        res.status(201).json({ message: 'User and farm created successfully' });
    } catch (error) {
        next(error);
    }
};

// Sign-in function
const signin = async (req, res, next) => {
    const { email, password } = req.body;

    if (!email || !password || email === '' || password === '') {
        return next(errorHandling(400, 'All fields are required'));
    }

    try {
        const user = await User.findOne({ email });

        if (!user) {
            return next(errorHandling(404, 'User not found'));
        }

        const isMatch = bcrypt.compareSync(password, user.password);

        if (!isMatch) {
            return next(errorHandling(401, 'Invalid credentials'));
        }

        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
        const { password: pass, ...rest } = user._doc;
        res.status(200).cookie('access_token', token, {
            httpOnly: true,
        }).json(rest);
    } catch (error) {
        next(error);
    }
};

module.exports = { signup, signupWithCode, generateSignUpCode, signin };
