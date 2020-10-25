import 'package:ecommerce/constants.dart';
import 'package:flutter/material.dart';

class Alert {
  bar(context,text,errorCode){
    if(errorCode == 'ERROR_WEAK_PASSWORD')
      text = 'Weak Password';
    else if(errorCode == 'ERROR_INVALID_EMAIL')
      text = 'This email is incorrect';
    else if(errorCode == 'ERROR_EMAIL_ALREADY_IN_USE')
      text = 'Email already exist';
    else if(errorCode == 'ERROR_USER_NOT_FOUND')
      text = 'User not found';

    return SnackBar(
      content: Text(
        text,
        style: TextStyle(
            fontSize: 16
        ),
      ),
    );
  }
}