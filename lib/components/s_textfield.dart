import 'package:flutter/material.dart';
import 'package:study/utils/Constants.dart';
import 'package:study/utils/colors.dart';

class s_textfield extends StatelessWidget {
  final String label;
  final String type;
  final TextEditingController editingController;
  final FocusNode? nextFocusNode;
  final Function()? submited;
  final FocusNode? focusNode;
  final List<dynamic>? rules;
  const s_textfield({
    Key? key,
    required this.label,
    this.type = 'text',
    required this.editingController,
    this.nextFocusNode,
    this.focusNode,
    this.submited,
    this.rules = const [],
  }) : super(key: key);
  String? validator(String? value) {
    final rule =
        this.rules!.firstWhere((el) => el(value) is String, orElse: () => null);
    if (rule != null) return rule(value);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: type == 'password',
      keyboardType: Constants.typeKeyboard[type],
      controller: editingController,
      onFieldSubmitted: (_) {
        if (submited != null)
          submited!();
        else
          FocusScope.of(context).requestFocus(nextFocusNode);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      focusNode: focusNode,
      decoration: InputDecoration(
        label: Text(
          this.label,
          style: TextStyle(
            color: Colors_Theme.blue_Theme[700],
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: new BorderSide(color: Colors.transparent),
          borderRadius: new BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors_Theme.blue_Theme[50],
      ),
    );
  }
}
