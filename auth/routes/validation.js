module.exports = function validate(email, password) {
    if(!email.includes('@') || !email.includes('.')){
        return 'Invalid email format'
    }
    if(password.length < 6){
        return 'Password is too short, less than 6'
    }
    return false
}