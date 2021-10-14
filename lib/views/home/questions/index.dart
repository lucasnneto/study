import 'package:flutter/material.dart';
import 'package:study/providers/language.dart';
import 'package:study/views/home/questions/mark.dart';

class QuestionBase extends StatelessWidget {
  const QuestionBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exercise = ModalRoute.of(context)!.settings.arguments as Exercise;
    return Mark(exercise: exercise);
  }
}
