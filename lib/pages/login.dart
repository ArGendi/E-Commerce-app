import 'dart:async';
import 'dart:ui';
import 'package:ecommerce/pages/home.dart';
import 'package:ecommerce/providers/modelHud.dart';
import 'package:ecommerce/services/alert.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/constants.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _name;
  String _email;
  String _password;
  String _country;
  String _city;
  String _area;
  String _street;
  Position _currentPosition;
  final Geolocator geolocator = Geolocator();

  void _trySubmit(){
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formKey.currentState.save();
      print(_email);
      print(_password);
    }
  }

  _getLocation() async{
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position){
      setState(() {
        _currentPosition = position;
      });
    }).then((_) async{
      final coordinates = Coordinates(_currentPosition.latitude, _currentPosition.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      _country = first.countryName;
      _city = first.adminArea;
      _area = first.locality;
    }).catchError((e) {
      print(e);
    });
  }
  @override
  void initState() {
    _getLocation();
    super.initState();
  }

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
                  if(!_isLogin)
                  TextFormField(
                    key: ValueKey('name'),
                    validator: (value){
                      if(value.isEmpty)
                        return 'Enter your full name';
                      return null;
                    },
                    onSaved: (value){
                      _name = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
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
                    key: ValueKey('email'),
                    validator: (value){
                      if(value.isEmpty || !value.contains('@'))
                        return 'Invalid Email Address';
                      return null;
                    },
                    onSaved: (value){
                      _email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
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
                    key: ValueKey('password'),
                    validator: (value){
                      if(value.isEmpty || value.length < 6)
                        return 'Password must be longer than 6';
                      return null;
                    },
                    onSaved: (value){
                      _password = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
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
                  if(!_isLogin)
                    TextFormField(
                    initialValue: _country,
                    readOnly: true,
                    key: ValueKey('country'),
                    validator: (value){
                      if(value.isEmpty)
                        return 'Please open location';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Country',
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
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
                  if(!_isLogin)
                    TextFormField(
                      initialValue: _city,
                      key: ValueKey('city'),
                      validator: (value){
                        if(value.isEmpty)
                          return 'Enter your city';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
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
                  if(!_isLogin)
                    TextFormField(
                      initialValue: _area,
                      key: ValueKey('area'),
                      validator: (value){
                        if(value.isEmpty)
                          return 'Enter your area';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Area',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
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
                  if(!_isLogin)
                    TextFormField(
                      key: ValueKey('street'),
                      validator: (value){
                        if(value.isEmpty)
                          return 'Enter your street';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Street',
                        labelStyle: TextStyle(
                          color: Colors.grey[700],
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
                      _isLogin ? 'Login': 'SignUp',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onPressed: _trySubmit,
                    shape: Border.all(),
                  ),
                  FlatButton(
                    child: Text(_isLogin ? 'Create Account' : 'Have one already'),
                    onPressed: (){
                      _getLocation();
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
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
