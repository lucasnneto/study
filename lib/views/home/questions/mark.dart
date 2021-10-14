import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/colors.dart';
import 'package:study/widget/modal_fail.dart';
import 'package:study/widget/modal_sucess.dart';
import 'package:study/widget/tab_navigator.dart';
import 'package:collection/collection.dart';

class Mark extends StatelessWidget {
  final Exercise exercise;
  const Mark({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);

    final questions = exercise.options
        .map((el) => el.toString().replaceAll('*', ''))
        .toList();
    questions.shuffle();
    final opts = {0: "A", 1: "B", 2: "C", 3: "D", 4: "E"};
    bool load = false;
    int selectedValue = -1;
    Color cor = Colors_Theme.blue_Theme;

    return StatefulBuilder(builder: (ctx, setState) {
      validValue() {
        final select = questions[selectedValue];
        final rightValue = exercise.options
            .firstWhere((element) =>
                element.toString().endsWith("*") &&
                element.toString().startsWith("*"))
            .toString()
            .replaceAll("*", "");
        final indexListRight =
            questions.indexWhere((element) => element == rightValue);

        final isAnswer = select.toString() == rightValue;
        showDialog(
            barrierDismissible: false,
            context: ctx,
            builder: (c) {
              return Dialog(
                child: isAnswer
                    ? modal_sucess(mainFunction: () {
                        Navigator.of(c).pop();
                      })
                    : modal_fail(mainFunction: () {
                        Navigator.of(c).pop();
                        setState(() {
                          cor = Colors_Theme.error;
                        });
                      }, subFunction: () {
                        Navigator.of(c).pop();
                        setState(() {
                          selectedValue = indexListRight;
                          cor = Colors_Theme.success;
                        });
                      }),
              );
            });
      }

      return LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      mini: true,
                      elevation: 1,
                      // backgroundColor: Colors.transparent,
                      shape: CircleBorder(),
                      onPressed: () {
                        TabNavigator.of(context).pop(context);
                      },
                      child: Icon(Icons.chevron_left),
                    ),
                    Text(
                      exercise.theme,
                      style: TextStyle(
                        color: Colors_Theme.blue_Theme[700],
                        fontSize: 27,
                      ),
                    ),
                    SizedBox()
                  ],
                ),
                SizedBox(height: 25),
                Html(data: exercise.text),
                SizedBox(height: 15),
                ...questions
                    .mapIndexed(
                      (index, e) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              cor = Colors_Theme.blue_Theme;
                              selectedValue = index;
                            });
                          },
                          child: Container(
                              width: constraints.maxWidth,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              decoration: BoxDecoration(
                                color:
                                    selectedValue == index ? cor : Colors.white,
                                border: Border.all(
                                  color: Colors_Theme.blue_Theme[50]!,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text('${opts[index]!}.',
                                      style: TextStyle(
                                        color: selectedValue == index
                                            ? Colors.white
                                            : Colors_Theme.blue_Theme[700],
                                        fontSize: 25,
                                      )),
                                  SizedBox(width: 15),
                                  Text(e,
                                      style: TextStyle(
                                        color: selectedValue == index
                                            ? Colors.white
                                            : Colors_Theme.blue_Theme[700],
                                        fontSize: 25,
                                      )),
                                ],
                              )),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
            s_button(
                function: selectedValue == -1 ? null : validValue,
                label: "Verificar")
          ],
        );
      });
    });
  }
}
