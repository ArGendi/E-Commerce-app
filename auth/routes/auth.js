const router = require('express').Router()
const User = require('../model/user')
const bcrypt = require('bcryptjs')
const jwt = require('jsonwebtoken')

//Validation
const joi = require('@hapi/joi')

router.post('/register', async (req, res) => {
    //Check user exist
    const emailExist = await User.findOne({email: req.body.email})
    if(emailExist) return res.status(400).send("Email already exist")

    //Hash password
    const salt = await bcrypt.genSalt(10)
    const hashedPassword = await bcrypt.hash(req.body.password, salt)

    //Create new user
    const user = new User({
        name: req.body.name,
        email: req.body.email,
        password: hashedPassword
    })
    try{
        const savedUser = await user.save()
        res.send("user id: " + savedUser._id)
    }catch(err){
        res.status(400).send(err)
    }
})

router.post('/login', async (req, res) => {
    //Check email exist
    const userExisted = await User.findOne({email: req.body.email})
    if(!userExisted) return res.status(400).send("Email is not found")

    //check password
    const validPassword = await bcrypt.compare(req.body.password, userExisted.password)
    if(!validPassword) return res.status(400).send("Wrong Password")
    
    //Create & assign token
    const token = jwt.sign({_id: userExisted._id}, process.env.TOKEN_SECRET)
    res.header('auth-token', token).send(token)
})

module.exports = router