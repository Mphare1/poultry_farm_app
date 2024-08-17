const User = require("../model/user.model");
const bcryptjs = require('bcryptjs');

const signup = async (req, res) => {
 const { username, email, password } = req.body;

    if (!username || !email || !password || username === '' || email === '' || password === '') {
        res.status(400).json({ message: 'All fields are required' });
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
    res.status(500).json({ message: 'Internal server error' });
}
};


module.exports = { signup };