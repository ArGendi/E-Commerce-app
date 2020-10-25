import 'package:ecommerce/providers/modelHud.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:ecommerce/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class EmailRequired extends StatefulWidget {
  static final String id = 'email required';

  @override
  _EmailRequiredState createState() => _EmailRequiredState();
}

class _EmailRequiredState extends State<EmailRequired> {
  final TextEditingController emailController = TextEditingController();
  final Auth _auth = Auth();
  bool infoAppear = false;

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
                'Forget \nPassword',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20,),
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
                    Builder(
                      builder: (context) => FlatButton(
                        onPressed: () async{
                          String email = emailController.text;
                          final modalHud = Provider.of<ModelHud>(context, listen: false);
                          modalHud.changeLoadingValue(true);
                          if(emailController.text == ''){
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Empty Email',
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              ),
                            ));
                          }
                          else{
                            try{
                              _auth.resetPassword(email);
                              modalHud.changeLoadingValue(false);
                              setState(() {
                                infoAppear = true;
                              });
                              Future.delayed(const Duration(seconds: 5), () {
                                Navigator.pop(context);
                              });
                            }
                            on PlatformException catch(e){
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  e.message,
                                  style: TextStyle(
                                      fontSize: 16
                                  ),
                                ),
                              ));
                            }
                          }
                          modalHud.changeLoadingValue(false);
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
                            'Reset Password',
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Check your email to reset your Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: infoAppear ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
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
