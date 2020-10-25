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

class LoginPage extends StatelessWidget {
  static final String id = 'login';
  final Auth _auth = Auth();
  final Alert _alert = Alert();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String validation(){
    String errorText = '';
    if(emailController.text.isEmpty)
      errorText = 'You forgot your email';
    else if(passwordController.text.isEmpty)
      errorText = 'Oh, you have to enter a password';
    return errorText;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                'Login',
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
                    SizedBox(height: size.height * 0.02,),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, EmailRequired.id);
                        },
                        child: Text(
                          'Forget Password ?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03,),
                    Builder(
                      builder: (context) => FlatButton(
                        onPressed: () async{
                          final modalHud = Provider.of<ModelHud>(context, listen: false);
                          modalHud.changeLoadingValue(true);
                          String errorText = validation();
                          if(errorText.length > 0) {
                            modalHud.changeLoadingValue(false);
                            Scaffold.of(context).showSnackBar(_alert.bar(context, errorText, ''));
                          }
                          else {
                            final String email = emailController.text;
                            final String password = passwordController.text;
                            try{
                              final account = await _auth.login(email, password);
                              if(account != null){
                                modalHud.changeLoadingValue(false);
                                Navigator.pushReplacementNamed(context, HomePage.id);
                              }
                            }
                            on PlatformException catch(e){
                              modalHud.changeLoadingValue(false);
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
                            'LOGIN',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account ? ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, SignUpPage.id);
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: kMainColor1,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
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
