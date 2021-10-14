import 'package:flutter/material.dart';
import 'package:study/utils/colors.dart';

class s_button extends StatelessWidget {
  final Function()? function;
  final String label;
  final Color? color;
  final bool outlined;
  const s_button({
    Key? key,
    required this.function,
    required this.label,
    this.outlined = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return outlined
        ? OutlinedButton(
            onPressed: function,
            child: Text(label,
                style: TextStyle(
                    color: color != null ? color! : Colors_Theme.blue_Theme)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  width: 1.0,
                  color: color != null ? color! : Colors_Theme.blue_Theme),
              minimumSize: Size(250, 52),
              shape: StadiumBorder(),
            ),
          )
        : ElevatedButton(
            onPressed: function,
            child: Text(label, style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              primary: color,
              minimumSize: Size(250, 52),
              shape: StadiumBorder(),
            ),
          );
  }
}
