import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_ativity.dart';
import 'package:study/components/s_bar.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/colors.dart';
import 'package:study/widget/tab_navigator.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  final Map<double, String> StatusGeral = {0: "", 0.3: "start", 1: "complete"};
  @override
  Widget build(BuildContext context) {
    Language lang = Provider.of<Language>(context);
    Auth auth = Provider.of<Auth>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    final Map<String, double> invertStatus = {
      "": 0,
      "start": 0.3,
      "complete": 1
    };
    double getPercent() {
      if (lang.item!.exercise.length == 0) return 0;
      if (auth.Exercise.length == 0) return 0;
      final prog = auth.Exercise.fold<num>(
          0,
          (previousValue, element) =>
              invertStatus[element.status]! + previousValue);
      return (prog / lang.item!.exercise.length);
    }

    final data = lang.item!.exercise.map((e) {
      final state = auth.Exercise.firstWhere((element) => element.id == e.id,
          orElse: () => Progress(id: "", type: "", status: ""));
      double value = 0;
      if (state.status == 'complete') {
        value = 1;
      } else if (state.status == 'start') {
        value = 0.3;
      }
      final les = Exercise(
          id: e.id,
          type: e.type,
          theme: e.theme,
          lessionId: e.lessionId,
          text: e.text,
          options: e.options,
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
                              title: e.theme,
                              text: e.type == 'mark'
                                  ? 'Alternativas'
                                  : 'Completar',
                              percente: e.status!,
                              onTap: () {
                                if (StatusGeral[e.status] == '') {
                                  final value = e.status == 0 ? 0.3 : e.status;
                                  e.status = value;
                                  auth.changeStatus({
                                    "id": e.id,
                                    "type": "exercise",
                                    "status": value == 0
                                        ? "start"
                                        : StatusGeral[value]
                                  }, context);
                                }
                                TabNavigator.of(context)
                                    .push(context, Routes_Main.QUESTION,
                                        arguments: e)
                                    .then((value) {
                                  setState(() {});
                                });
                                ;
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
