const jwt = require("jsonwebtoken")

module.exports =  function auth(req, res, next) {
    const token = req.header('auth-token')
    if(!token) return res.status(401).send("Access denied")
    try{
        const verifed = jwt.verify(token, process.env.TOKEN_SECRET)
        req.user = verifed
        next()
    }catch(err){
        res.status(400).send("Invalid token")
    }
}