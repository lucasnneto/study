import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_ativity.dart';
import 'package:study/components/s_bar.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/colors.dart';
import 'package:study/widget/tab_navigator.dart';

class LessonList extends StatefulWidget {
  const LessonList({Key? key}) : super(key: key);

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    Language lang = Provider.of<Language>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);

    final Map<double, String> StatusGeral = {
      0: "",
      0.3: "start",
      1: "complete"
    };
    final Map<String, double> invertStatus = {
      "": 0,
      "start": 0.3,
      "complete": 1
    };

    double getPercent() {
      if (lang.item!.lesson.length == 0) return 0;
      if (auth.Lessons.length == 0) return 0;
      return (auth.Lessons.length / lang.item!.lesson.length);
    }

    final data = lang.item!.lesson.map((e) {
      final state = auth.Lessons.firstWhere((element) => element.id == e.id,
          orElse: () => Progress(id: "", type: "", status: ""));
      double value = invertStatus[state.status]!;
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
        Container(
          height: mediaQuery.size.height - 330,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...data
                    .map((e) => Column(
                          children: [
                            s_ativity(
                              title: e.title,
                              text: e.text,
                              percente: e.status!,
                              onTap: () {
                                if (StatusGeral[e.status] == '') {
                                  final value = e.status == 0 ? 0.3 : e.status;
                                  e.status = value;
                                  auth.changeStatus({
                                    "id": e.id,
                                    "type": "lesson",
                                    "status": value == 0
                                        ? "start"
                                        : StatusGeral[value]
                                  }, context);
                                }
                                TabNavigator.of(context)
                                    .push(context, Routes_Main.STUDY,
                                        arguments: e)
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ))
                    .toList(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
