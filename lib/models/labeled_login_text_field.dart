import 'package:flutter/material.dart';
import 'package:read_right_project/models/login_text_field.dart';

class LabelledLoginTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData fieldIcon;
  final String labelText;
  const LabelledLoginTextField({super.key, required this.textEditingController, required this.fieldIcon, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$labelText: ",
          ),
          SizedBox(width: 10.0),
          LoginTextField(
            textEditingController: textEditingController, 
            fieldIcon: fieldIcon
          )
        ],
      ),
    );
  }
}