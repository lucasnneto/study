import 'package:flutter/material.dart';
import 'package:study/utils/colors.dart';

class s_ativity extends StatelessWidget {
  final String title;
  final String text;
  final double percente;
  final Function onTap;
  const s_ativity({
    Key? key,
    required this.title,
    required this.text,
    required this.percente,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String filterText(String text) {
      if (text == null) return "";
      final value = text.length >= 49 ? (text.substring(0, 50) + '...') : text;
      return value;
    }

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 70,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percente,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors_Theme.blue_Theme[50],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,
                          style: TextStyle(
                            color: Colors_Theme.blue_Theme[500],
                            fontSize: 20,
                          )),
                      Text(filterText(text),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          )),
                    ],
                  ),
                  Text('${(percente * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Colors_Theme.blue_Theme[500],
                        fontSize: 20,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
