import 'package:flutter/material.dart';
import 'package:study/utils/Http.dart';

class Lesson {
  final String id;
  final String text;
  final String video;
  final List<dynamic> url;
  Lesson({
    required this.id,
    required this.text,
    required this.video,
    required this.url,
  });
}

class Exercise {
  final String id;
  final String lessionId;
  final String type;
  final String text;
  final List<dynamic> options;
  Exercise({
    required this.id,
    required this.type,
    required this.lessionId,
    required this.text,
    required this.options,
  });
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
          lesson.add(Lesson(
              id: l['id'], text: l['text'], video: l['video'], url: l['url']));
        });
        List<Exercise> exercise = [];
        (res.data['exercise'] as Map<String, dynamic>).forEach((k, l) {
          exercise.add(Exercise(
              id: l['id'],
              text: l['text'],
              type: l['type'],
              options: l['options'],
              lessionId: l['lessionId']));
        });
        _item = Topic(lesson: lesson, exercise: exercise);
      }
    } catch (e) {
      print(e);
    }
    return Future.value();
  }
}
