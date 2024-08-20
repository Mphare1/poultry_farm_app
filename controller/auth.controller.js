const User = require("../model/user.model");
const bcrypt = require('bcrypt');
const errorHandling = require("../utils/error");
const jwt = require('jsonwebtoken');

const signup = async (req, res, next) => {
    const { username, email, password } = req.body;

    if (!username || !email || !password || username === '' || email === '' || password === '') {
        return next(errorHandling(400, 'All fields are required'));
    }

    const hashPassword = bcrypt.hashSync(password, 10);

    const newUser = new User({
        username,
        email,
        password: hashPassword, // Save the hashed password
    });

    try {
        await newUser.save();
        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        next(error);
    }
};

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

        const token = jwt.sign({ id: user._id },
            process.env.JWT_SECRET);
        const { password: pass, ...rest} = user._doc;
            res.status(200).cookie('access_token', token, {
                httpOnly: true,
            }).json(rest);
    } catch (error) {
        next(error);
    }
}

module.exports = { signup, signin };