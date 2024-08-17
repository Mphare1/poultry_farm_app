const User = require("../model/user.model");
const bcryptjs = require('bcryptjs');
const errorHandling = require("../utils/error");

const signup = async (req, res, next) => {
 const { username, email, password } = req.body;

    if (!username || !email || !password || username === '' || email === '' || password === '') {
        next(errorHandling(400, 'All fields are required'));
    }

    const hashPassword = bcrypt.hashSync(password, 10);

    const newUser = new User({
        username,
        email,
        password,
    });
    try {
    await newUser.save();
    res.status(201).json({ message: 'User created successfully' });
}
 catch (error) {
    next(error);
}
};


module.exports = { signup };