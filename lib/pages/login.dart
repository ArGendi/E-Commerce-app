import 'dart:ui';
import 'package:ecommerce/pages/email_requried.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/providers/modelHud.dart';
import 'package:ecommerce/services/alert.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:ecommerce/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/constants.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    validator: (value){
                      if(value.isEmpty || !value.contains('@'))
                        return 'Invalid Email Address';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)
                      ),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  SizedBox(height: size.height * .01,),
                  TextFormField(
                    validator: (value){
                      if(value.isEmpty || value.length < 6)
                        return 'Password must be longer than 6';
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                    ),
                    cursorColor: Colors.black,
                  ),
                  SizedBox(height: size.height * .03,),
                  FlatButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onPressed: (){},
                    shape: Border.all(),
                  ),
                  FlatButton(
                    child: Text('Create Account'),
                    onPressed: (){},
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
