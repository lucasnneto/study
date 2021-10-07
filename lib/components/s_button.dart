import 'package:flutter/material.dart';

class s_button extends StatelessWidget {
  final Function() function;
  final String label;
  const s_button({
    Key? key,
    required this.function,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(250, 52),
        shape: StadiumBorder(),
      ),
    );
  }
}
