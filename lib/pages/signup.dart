import 'dart:ui';
import 'package:ecommerce/pages/email_verification.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/providers/modelHud.dart';
import 'package:ecommerce/services/alert.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:ecommerce/widgets/alert.dart';
import 'package:ecommerce/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/constants.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  static String id = 'sign up';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Auth _auth = Auth();
  Alert _alert = Alert();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String validation(){
    String errorText = '';
    if(nameController.text.isEmpty)
      errorText = 'You forgot your full name';
    else if(emailController.text.isEmpty)
      errorText = 'You forgot your email';
    else if(passwordController.text.isEmpty)
      errorText = 'Oh, you have to enter a password';
    else if(confirmPasswordController.text != passwordController.text)
      errorText = 'Password does not match';
    return errorText;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kMainColor1),
        ),
        inAsyncCall: Provider.of<ModelHud>(context).loading,
        child: Column(
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
                'Register',
                style: Theme.of(context).textTheme.headline2.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03,),
            Expanded(
              child: Form(
                child: ListView(
                  children: <Widget>[
                    CustomTextField(
                      icon: Icons.perm_identity,
                      hintText: 'Full Name',
                      controller: nameController,
                    ),
                    SizedBox(height: size.height * 0.03,),
                    CustomTextField(
                      icon: Icons.email,
                      hintText: 'Email',
                      controller: emailController,
                    ),
                    SizedBox(height: size.height * 0.03,),
                    CustomTextField(
                      icon: Icons.vpn_key,
                      hintText: 'Password',
                      hidden: true,
                      controller: passwordController,
                    ),
                    SizedBox(height: size.height * 0.03,),
                    CustomTextField(
                      icon: Icons.vpn_key,
                      hintText: 'Confirm Password',
                      hidden: true,
                      controller: confirmPasswordController,
                    ),
                    SizedBox(height: size.height * 0.05,),
                    Builder(
                      builder: (context) => FlatButton(
                        onPressed: () async{
                          final modelHud = Provider.of<ModelHud>(context, listen: false);
                          modelHud.changeLoadingValue(true);
                          String errorText = validation();
                          if(errorText.length > 0) {
                            modelHud.changeLoadingValue(false);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(errorText),
                            ));
                          }
                          else {
                            String email = emailController.text;
                            String password = passwordController.text;
                            try {
                              await _auth.signUp(email, password);
                              await _auth.login(email, password);
                              Navigator.pushNamedAndRemoveUntil(context, HomePage.id, ModalRoute.withName('/'));
                              modelHud.changeLoadingValue(false);
                            }
                            on PlatformException catch(e){
                              modelHud.changeLoadingValue(false);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(e.message),
                              ));
                            }
                          }
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
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
