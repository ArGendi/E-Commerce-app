import 'package:ecommerce/constants.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailVerification extends StatefulWidget {
  static final String id = 'email verification';
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: size.height * .38,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kMainColor1,
                  kMainColor2,
                ],
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
            ),
            child: Text(
              'Email\nVerification',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Verification email has been sent to ${data['email']},'
                  ' please check your email address so you can login',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Builder(
            builder: (context) => FlatButton(
              onPressed: () async{
                Navigator.popUntil(context,  ModalRoute.withName(LoginPage.id));
              },
              child: Container(
                width: size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kMainColor1,
                      kMainColor2,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Get it',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
