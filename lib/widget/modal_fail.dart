import 'package:flutter/material.dart';
import 'package:study/components/s_button.dart';
import 'package:study/utils/colors.dart';

class modal_fail extends StatelessWidget {
  final Function() mainFunction;
  final Function() subFunction;
  const modal_fail(
      {Key? key, required this.mainFunction, required this.subFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 350,
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Resposta Errada",
            style: TextStyle(
              color: Colors_Theme.error,
              fontSize: 25,
            ),
          ),
          Container(
            child: Icon(
              Icons.close,
              color: Colors_Theme.error,
              size: 100,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors_Theme.error,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(90),
            ),
          ),
          s_button(
            function: mainFunction,
            label: "Tentar Novamente",
            color: Colors_Theme.error,
          ),
          s_button(
            function: subFunction,
            label: "Resposta",
            outlined: true,
            color: Colors_Theme.error,
          )
        ],
      ),
    );
  }
}
