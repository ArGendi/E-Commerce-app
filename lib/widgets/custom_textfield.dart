import 'package:ecommerce/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String hintText;
  final IconData icon;
  final bool hidden;
  final TextEditingController controller;

  const CustomTextField({Key key, this.hintText, this.icon, this.hidden = false, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: controller,
            obscureText: hidden,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey[600],),
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
