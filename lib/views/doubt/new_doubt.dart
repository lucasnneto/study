import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/doubt.dart';
import 'package:study/utils/Rules.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/body.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/widget/tab_navigator.dart';

class newDoubt extends StatefulWidget {
  newDoubt({Key? key}) : super(key: key);

  @override
  State<newDoubt> createState() => _newDoubtState();
}

class _newDoubtState extends State<newDoubt> {
  final title = TextEditingController();

  final describe = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Doubts doubts = Provider.of<Doubts>(context);
    create() async {
      Auth auth = Provider.of<Auth>(context, listen: false);
      var isValid = _form.currentState!.validate();
      if (!isValid) return;
      final payload = {
        'title': title.text,
        'describe': describe.text,
        'userId': auth.userId,
        'userName': auth.userName
      };
      await doubts.addDoubt(payload, context);
    }

    return Body(
      child: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  mini: true,
                  // backgroundColor: Colors.transparent,
                  shape: CircleBorder(),
                  onPressed: () {
                    TabNavigator.of(context).pop(context);
                  },
                  child: Icon(Icons.chevron_left),
                ),
                Text(
                  'Qual a dúvida?',
                  style: TextStyle(
                    color: Colors_Theme.blue_Theme[700],
                    fontSize: 27,
                  ),
                ),
                SizedBox(),
              ],
            ),
            Column(
              children: [
                s_textfield(
                  label: "Titulo",
                  editingController: title,
                  rules: [Rules.required],
                ),
                SizedBox(
                  height: 10,
                ),
                s_textfield(
                  label: "Descrição do problema",
                  editingController: describe,
                  maxLines: 5,
                  rules: [Rules.required],
                  type: "multi",
                ),
              ],
            ),
            doubts.status == 'loading'
                ? Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(),
                  )
                : s_button(function: create, label: "Enviar")
          ],
        ),
      ),
    );
  }
}
