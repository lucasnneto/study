import 'package:flutter/material.dart';
import 'package:study/utils/Constants.dart';
import 'package:study/utils/colors.dart';

class s_textfield extends StatefulWidget {
  final String label;
  final String type;
  final TextEditingController editingController;
  final FocusNode? nextFocusNode;
  final Function()? submited;
  final FocusNode? focusNode;
  final List<dynamic>? rules;
  final Function()? onTap;
  final int? maxLines;
  final bool readOnly;
  s_textfield({
    Key? key,
    required this.label,
    required this.editingController,
    this.type = 'text',
    this.nextFocusNode,
    this.focusNode,
    this.submited,
    this.maxLines = 1,
    this.rules = const [],
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<s_textfield> createState() => _s_textfieldState();
}

class _s_textfieldState extends State<s_textfield> {
  String? validator(String? value) {
    final rule = this
        .widget
        .rules!
        .firstWhere((el) => el(value) is String, orElse: () => null);
    if (rule != null) return rule(value);

    return null;
  }

  @override
  bool _passwordVisible = false;

  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      obscureText: widget.type == 'password' && !_passwordVisible,
      keyboardType: Constants.typeKeyboard[widget.type],
      maxLines: widget.maxLines,
      controller: widget.editingController,
      onFieldSubmitted: (_) {
        if (widget.submited != null)
          widget.submited!();
        else
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        suffixIcon: widget.type == 'password'
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
        label: Text(
          this.widget.label,
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
