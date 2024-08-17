const User = require("../model/user.model");

const signup = async (req, res) => {
 const { username, email, password } = req.body;

    if (!username || !email || !password || username === '' || email === '' || password === '') {
        return res.status(400).json({ message: 'All fields are required' });
    }

    const newUser = new User({
        username,
        email,
        password,
    });

    await newUser.save();
    return res.status(201).json({ message: 'User created successfully' });
}


module.exports = { signup };