import 'package:flutter/material.dart';

class s_button extends StatelessWidget {
  final Function() function;
  const s_button({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Text('Entrar', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(250, 52),
        shape: StadiumBorder(),
      ),
    );
  }
}
