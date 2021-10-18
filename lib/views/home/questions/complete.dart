import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/colors.dart';
import 'package:study/widget/modal_fail.dart';
import 'package:study/widget/modal_sucess.dart';
import 'package:study/widget/tab_navigator.dart';
import 'package:collection/collection.dart';

class Complete extends StatelessWidget {
  final Exercise exercise;
  const Complete({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    bool load = false;
    TextEditingController value = TextEditingController();
    FocusScopeNode foco = FocusScopeNode();

    return StatefulBuilder(builder: (ctx, setState) {
      nextQuestion() async {
        final payload = {
          "id": exercise.id,
          "status": "complete",
          "type": "exercise"
        };
        setState(() {
          load = true;
        });
        await auth.changeStatus(payload, context);
        Provider.of<Language>(context, listen: false)
            .changeExercise(payload['id']!, context);
        setState(() {
          load = false;
          foco.unfocus();
        });
      }

      validValue() {
        final select = value.text;
        if (select.isEmpty) return;

        final isAnswer = exercise.options
            .map((el) => el.toString())
            .toList()
            .contains(select);
        showDialog(
            barrierDismissible: false,
            context: ctx,
            builder: (c) {
              Auth auth = Provider.of<Auth>(c);
              if (!auth.isAuth && Navigator.of(c).canPop())
                Navigator.of(c).pop();
              return Dialog(
                child: isAnswer
                    ? modal_sucess(mainFunction: () {
                        Navigator.of(c).pop();
                        nextQuestion();
                      })
                    : modal_fail(mainFunction: () {
                        Navigator.of(c).pop();
                        setState(() {
                          value.text = "";
                        });
                      }, subFunction: () {
                        Navigator.of(c).pop();
                        setState(() {
                          value.text = exercise.options[0].toString();
                        });
                      }),
              );
            });
      }

      return LayoutBuilder(builder: (context, constraints) {
        final keyb = MediaQuery.of(context).viewInsets.bottom;
        return Container(
          height: constraints.maxHeight - keyb,
          child: Column(
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
                ],
              ),
              Container(
                  width: constraints.maxWidth * 0.85,
                  child: s_textfield(
                    label: "",
                    focusNode: foco,
                    editingController: value,
                    readOnly: load,
                  )),
              load
                  ? Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(),
                    )
                  : s_button(function: validValue, label: "Verificar"),
            ],
          ),
        );
      });
    });
  }
}
