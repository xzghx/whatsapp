import 'package:flutter/material.dart';

class MyTextInputFields extends StatelessWidget {
  final bool obscured;
  final String hint;
  final IconData iconData;
  final validator; //is a function like String func(String value)
  final  onSaved; //is a callback method that is called when form's  save is called

  MyTextInputFields(
      {@required this.obscured,
      @required this.hint,
      @required this.iconData,
      @required this.validator,
      @required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        obscureText: obscured,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(right: 8, top: 8),
            errorStyle: TextStyle(color: Colors.amber),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber)),
            focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            icon: Icon(
              iconData,
              color: Colors.white,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }
}