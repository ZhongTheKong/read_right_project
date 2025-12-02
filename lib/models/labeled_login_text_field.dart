import 'package:flutter/material.dart';
import 'package:read_right_project/models/login_text_field.dart';

/// -------------------------------------------------------------
/// LabelledLoginTextField
///
/// A reusable widget that displays a label alongside a login text field.
///
/// PRE:
///   • Requires a TextEditingController for the text field.
///   • Requires an IconData to display inside the text field.
///   • Requires a labelText string to display as the label.
///
/// POST:
///   • Renders a Row containing the label and a LoginTextField with spacing.
///   • The text entered by the user can be accessed via the provided controller.
/// -------------------------------------------------------------
class LabelledLoginTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData fieldIcon;
  final String labelText;

  const LabelledLoginTextField({
    super.key,
    required this.textEditingController,
    required this.fieldIcon,
    required this.labelText
  });

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
          const SizedBox(width: 10.0),
          LoginTextField(
            textEditingController: textEditingController, 
            fieldIcon: fieldIcon,
          ),
        ],
      ),
    );
  }
}
