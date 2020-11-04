const mongoose = require('mongoose')

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        min: 6,
        max: 255
    },
    email: {
        type: String,
        required: true,
        min: 6,
        max: 255
    },
    password: {
        type: String,
        required: true,
        min: 6,
        max: 1024
    },
    createAt: {
        type: Date,
        default: Date.now,
    },
    country: {
        type: String,
        required: true,
        max: 255
    },
    area: {
        type: String,
        required: true,
        max: 255
    },
    city: {
        type: String,
        required: true,
        max: 255
    },
    gender: {
        type: String,
        required: true,
    },
    street: {
        type: String
    },
    mobile: {
        type: String,
        required: true,
        min: 11,
        max: 255
    }
})

module.exports = mongoose.model('User', userSchema)