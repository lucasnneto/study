import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_ativity.dart';
import 'package:study/components/s_bar.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/colors.dart';

class LessonList extends StatelessWidget {
  const LessonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Language lang = Provider.of<Language>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);
    double getPercent() {
      if (lang.item!.lesson.length == 0) return 0;
      if (auth.Lessons.length == 0) return 0;
      return (auth.Lessons.length / lang.item!.lesson.length);
    }

    final data = lang.item!.lesson.map((e) {
      final state = auth.Lessons.firstWhere((element) => element.id == e.id,
          orElse: () => Progress(id: "", type: "", status: ""));
      double value = 0;
      if (state.status == 'complete') {
        value = 1;
      } else if (state.status == 'start') {
        value = 0.3;
      }
      final les = Lesson(
          id: e.id,
          text: e.text,
          title: e.title,
          video: e.video,
          url: e.url,
          status: e.status);
      les.status = value;
      return les;
    }).toList();

    return Column(
      children: [
        Container(
            height: 100,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors_Theme.blue_Theme[50]!,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: s_bar(
              label: "Nível do estudo",
              percentege: getPercent(),
            )),
        SizedBox(height: 20),
        ...data
            .map((e) => Column(
                  children: [
                    s_ativity(
                      title: e.title,
                      text: e.text,
                      percente: e.status!,
                      onTap: () {
                        print(e.title);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ))
            .toList(),
      ],
    );
  }
}
