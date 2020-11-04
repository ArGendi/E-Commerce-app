import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Authentication extends StatefulWidget {
  static final String id = 'auth';

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isMale = true;
  bool _isLoading = false;
  bool _ableToLoad = true;
  String _name;
  String _email;
  String _password;
  String _country = "";
  String _city = "";
  String _area = "";
  String _street;
  String _countryCode = "";
  String _mobile;
  Position _currentPosition;
  final Geolocator geolocator = Geolocator();

  void _trySubmit(BuildContext ctx) async{
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      var response;
      _formKey.currentState.save();
      setState(() {_isLoading = true;});
      try{
        if(_isLogin){
          response = await _post('http://10.0.2.2:8000/user/login',{
            "email": _email.trim(),
            "password": _password,
          });
        }
        else{
          response = await _post('http://10.0.2.2:8000/user/register',{
            "name": _name.trim(),
            "email": _email.trim(),
            "password": _password,
            "country": _country,
            "city": _city,
            "area": _area,
            "gender": _isMale ? 'male' : 'female',
            "street": _street,
            "mobile": _countryCode + _mobile.trim(),
          });
          print("here");
        }
        if(response.statusCode >= 400){
          Scaffold.of(ctx).showSnackBar(
              SnackBar(
                content: Text(response.body),
              ),
          );
        }
        else Navigator.pushReplacementNamed(context, HomePage.id);
        setState(() {_isLoading = false;});
      }catch(e){
        print(e);
      }
    }
  }

  Future<dynamic> _getLocation() async{
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final coordinates = Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  Future<http.Response> _post(url, data) async{
    var response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode(data),
    );
    return response;
  }

    @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: FutureBuilder(
                  future: _ableToLoad ? _getLocation() : null,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    _ableToLoad = false;
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      );
                    }
                    else{
                      return Form(
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
                            SizedBox(height: size.height * .005,),
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
                            SizedBox(height: size.height * .005,),
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
                            SizedBox(height: size.height * .005,),
                            if(!_isLogin)
                              TextFormField(
                                initialValue: snapshot.hasData ? snapshot.data.countryName : "",
                                key: ValueKey('country'),
                                validator: (value){
                                  if(value.isEmpty)
                                    return 'Please Enter your country';
                                  return null;
                                },
                                onSaved: (value){
                                  _country = value;
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
                            SizedBox(height: size.height * .005,),
                            if(!_isLogin)
                              TextFormField(
                                initialValue: snapshot.hasData ? snapshot.data.adminArea : "",
                                key: ValueKey('city'),
                                validator: (value){
                                  if(value.isEmpty)
                                    return 'Enter your city';
                                  return null;
                                },
                                onSaved: (value){
                                  _city = value;
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
                            SizedBox(height: size.height * .005,),
                            if(!_isLogin)
                              TextFormField(
                                initialValue: snapshot.hasData ? snapshot.data.locality : "",
                                key: ValueKey('area'),
                                validator: (value){
                                  if(value.isEmpty)
                                    return 'Enter your area';
                                  return null;
                                },
                                onSaved: (value){
                                  _area = value;
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
                                onSaved: (value){
                                  _street = value;
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
                            SizedBox(height: size.height * .005,),
                            if(!_isLogin)
                              Row(
                                children: <Widget>[
                                  CountryCodePicker(
                                    onChanged: (value){
                                      _countryCode = value.toString();
                                    },
                                    initialSelection: snapshot.hasData ? snapshot.data.countryCode :'EG',
                                    showCountryOnly: true,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value){
                                        if(value.isEmpty) return 'Enter your mobile number';
                                        return null;
                                      },
                                      onSaved: (value){
                                        _mobile = value;
                                      },
                                      key: ValueKey('mobile'),
                                      decoration: InputDecoration(
                                        hintText: 'Mobile',
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black)
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red)
                                        ),
                                      ),
                                      cursorColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: size.height * .005,),
                            if(!_isLogin)
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: _isMale,
                                    onChanged: (value){
                                      setState(() {
                                        _isMale = value;
                                      });
                                    },
                                    checkColor: Colors.white,
                                    activeColor: Colors.black,
                                  ),
                                  Text('Male'),
                                  Checkbox(
                                    value: !_isMale,
                                    onChanged: (value){
                                      setState(() {
                                        _isMale = !value;
                                      });
                                    },
                                    checkColor: Colors.white,
                                    activeColor: Colors.black,
                                  ),
                                  Text('Female'),
                                ],
                              ),
                            SizedBox(height: size.height * .03,),
                            Builder(
                              builder: (BuildContext ctx) =>
                                  FlatButton(
                                    child: _isLoading ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    ) : Text(
                                      _isLogin ? 'Login': 'SignUp',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: (){
                                      _trySubmit(ctx);
                                    },
                                    shape: Border.all(),
                                  ),
                            ),
                            FlatButton(
                              child: Text(_isLogin ? 'Create Account' : 'Have one already'),
                              onPressed: (){
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
            ),
          ),
        ),
      ),
    );
  }
}
