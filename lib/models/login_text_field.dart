import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData fieldIcon;
  const LoginTextField({super.key, required this.textEditingController, required this.fieldIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      child: TextField(
        controller: textEditingController,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.black
        ),
        decoration: InputDecoration(
          labelText: '',
          labelStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.black
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0
            ),
          ),
          prefixIcon: Icon(
            fieldIcon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}