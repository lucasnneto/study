import 'package:flutter/material.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/Http.dart';
import 'package:study/widget/tab_navigator.dart';

class Lesson {
  final String id;
  final String text;
  final String title;
  final String video;
  final List<dynamic> url;
  double? status;
  Lesson({
    required this.id,
    required this.text,
    required this.title,
    required this.video,
    required this.url,
    this.status = 0,
  });

  static Lesson toClass(Map<String, dynamic?> map) {
    return Lesson(
        id: map['id'],
        text: map['text'],
        title: map['title'],
        video: map['video'],
        url: map['url']);
  }
}

class Exercise {
  final String id;
  final String lessionId;
  final String type;
  final String theme;
  final String text;
  final List<dynamic> options;
  double? status;
  Exercise({
    required this.id,
    required this.type,
    required this.lessionId,
    required this.text,
    required this.theme,
    required this.options,
    this.status = 0,
  });
  static Exercise toClass(Map<String, dynamic?> map) {
    return Exercise(
        id: map['id'],
        text: map['text'],
        type: map['type'],
        theme: map['theme'],
        options: map['options'],
        lessionId: map['lessionId']);
  }
}

class Topic {
  List<Lesson> lesson;
  List<Exercise> exercise;
  Topic({
    required this.lesson,
    required this.exercise,
  });
}

class Language with ChangeNotifier {
  String language = "";
  Topic? _item = null;
  Topic? get item {
    return _item;
  }

  int get qtdtasks {
    return _item != null ? _item!.exercise.length + _item!.lesson.length : 0;
  }

  Future<void> loadLanguage(String lg) async {
    language = lg;
    final dio = Http.dio;
    try {
      final res = await dio.get('language/$language.json');
      if (res.data != null) {
        List<Lesson> lesson = [];
        (res.data['lesson'] as Map<String, dynamic>).forEach((k, l) {
          lesson.add(Lesson.toClass(l));
        });
        List<Exercise> exercise = [];
        (res.data['exercise'] as Map<String, dynamic>).forEach((k, l) {
          exercise.add(Exercise.toClass(l));
        });
        _item = Topic(lesson: lesson, exercise: exercise);
      }
    } catch (e) {
      print(e);
    }
    return Future.value();
  }

  void changeExercise(String id, BuildContext ctx) {
    final index = _item!.exercise.indexWhere((element) => element.id == id);
    TabNavigator.of(ctx).pop(ctx);
    if ((index + 1) < _item!.exercise.length) {
      TabNavigator.of(ctx)
          .push(ctx, Routes_Main.QUESTION,
              arguments: _item!.exercise[index + 1])
          .then((value) {
        notifyListeners();
      });
    }
  }
}
