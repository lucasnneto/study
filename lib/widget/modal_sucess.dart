import 'package:flutter/material.dart';
import 'package:study/components/s_button.dart';
import 'package:study/utils/colors.dart';

class modal_sucess extends StatelessWidget {
  final Function() mainFunction;
  const modal_sucess({Key? key, required this.mainFunction}) : super(key: key);

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
            "Resposta Correta",
            style: TextStyle(
              color: Colors_Theme.success,
              fontSize: 25,
            ),
          ),
          Container(
            child: Icon(
              Icons.check,
              color: Colors_Theme.success,
              size: 100,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors_Theme.success,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(90),
            ),
          ),
          s_button(
            function: mainFunction,
            label: "Continuar",
            color: Colors_Theme.success,
          )
        ],
      ),
    );
  }
}
