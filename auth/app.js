const express = require('express')
const app = express()
const mongoose = require('mongoose')
const dotenv = require('dotenv')
const bodyParser = require('body-parser')
const cors = require('cors')
const verify = require('./routes/verifyToken')
const User = require('./model/user')

//Import routes
const authRoute = require('./routes/auth')

dotenv.config()

//Connect to DB
mongoose.connect(
    process.env.DB_CONNECT,
    { useNewUrlParser: true, useUnifiedTopology: true },
    () => console.log('Connect to DB')
)

//Middleware
app.use(bodyParser.json())
app.use(cors())

//Route middleware
app.use('/api/user', authRoute)

app.listen(3000, () => console.log('server is running now..'))