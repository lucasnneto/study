import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_bar.dart';
import 'package:study/components/s_button.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/colors.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Language lang = Provider.of<Language>(context, listen: false);
      Auth auth = Provider.of<Auth>(context, listen: false);
      double getPercent() {
        if (lang.qtdtasks == 0) return 0;
        if (auth.lengthProgress == 0) return 0;
        return (auth.lengthProgress / lang.qtdtasks);
      }

      String getNextTopic() {
        if (lang.item == null) return "-";
        if (auth.progress == null) return lang.item!.lesson[0].title;
        final onlyLesson = auth.progress!
            .where((element) => element.type == 'lesson')
            .toList()
            .map((e) => e.id)
            .toList();
        if (onlyLesson.length == 0) return lang.item!.lesson[0].title;
        final lessonRemaining = lang.item!.lesson
            .where((element) => !onlyLesson.contains(element.id))
            .toList();
        if (lessonRemaining == 0) return 'Fim do estudo!';
        return lessonRemaining[0].title;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Começe a aprender",
            style: TextStyle(
              color: Colors_Theme.blue_Theme[700],
              fontSize: 27,
            ),
          ),
          Container(
            height: 100,
            width: constraints.maxWidth,
            child: s_bar(
              label: "Nível do estudo",
              percentege: getPercent(),
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(getNextTopic(),
                    style: TextStyle(
                      color: Colors_Theme.blue_Theme[700],
                      fontSize: 27,
                    )),
                Divider(color: Colors_Theme.blue_Theme[700]),
                Text("Próximo tópico")
              ],
            ),
          ),
          Image.asset(
            'assets/study.png',
            width: constraints.maxWidth * 0.6,
          ),
          s_button(function: () {}, label: "Volte a estudar")
        ],
      );
    });
  }
}