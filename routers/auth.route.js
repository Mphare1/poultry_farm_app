const express = require('express');
const { signup, signin, generateSignUpCode, signupWithCode } = require('../controller/auth.controller');

const router = express.Router();

router.post('/signup', signup);
router.post('/signin', signin);
router.post('/generate-signup-code', generateSignUpCode); // For managers/owners to generate codes
router.post('/signup-with-code', signupWithCode); // For users to sign up using the code

module.exports = router;