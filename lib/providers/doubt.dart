import 'package:flutter/cupertino.dart';
import 'package:study/utils/Http.dart';
import 'package:uuid/uuid.dart';

class Chat {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime date;
  Chat({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.date,
  });
}

class Doubt {
  final String id;
  final String userId;
  final String userName;
  final String title;
  final String status;
  final List<Chat> chat;
  final DateTime date;
  Doubt({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.status,
    required this.chat,
    required this.date,
  });
}

class Doubts with ChangeNotifier {
  List<Doubt> _items = [];
  String status = "";

  // Doubts([this._items = const []]);
  List<Doubt> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadDoubts() async {
    List<Doubt> loadedItems = [];
    final dio = Http.dio;
    try {
      final res = await dio.get('doubt.json');
      if (res.data != null) {
        res.data.forEach((doubtId, doubtData) {
          loadedItems.add(Doubt(
            id: doubtId,
            userId: doubtData['userId'],
            userName: doubtData['userName'],
            title: doubtData['title'],
            status: doubtData['status'],
            date: DateTime.parse(doubtData['date']),
            chat: (doubtData['chat'] as List<dynamic>).map((item) {
              return Chat(
                id: item['id'],
                userId: item['userId'],
                userName: item['userName'],
                text: item['text'],
                date: DateTime.parse(item['date']),
              );
            }).toList(),
          ));
        });
      }
      _items = loadedItems.reversed.toList();
    } catch (e) {
      print('erro');
    }
    notifyListeners();
    return Future.value();
  }

  void setState(type) {
    status = type;

    notifyListeners();
  }

  Future<void> addDoubt(Map<String, String?> payload, BuildContext ctx) async {
    setState('loading');
    final dio = Http.dio;
    final chat = [];
    final date = DateTime.now();
    final uuid = Uuid().v4();
    chat.add({
      "id": uuid,
      "userId": payload['userId'],
      "userName": payload['userName'],
      "text": payload['describe'],
      "date": date.toIso8601String(),
    });
    Map<String, dynamic> doubt = {
      "userId": payload['userId'],
      "userName": payload['userName'],
      "title": payload['title'],
      "chat": chat,
      "status": "open",
      "date": date.toIso8601String(),
    };
    try {
      final res = await dio.post(
        '/doubt.json',
        data: doubt,
      );

      _items.insert(
        0,
        Doubt(
          id: res.data['name'],
          date: DateTime.parse(doubt['date']),
          status: doubt['status'],
          title: doubt['title'],
          userId: doubt['userId'],
          userName: doubt['userName'],
          chat: chat
              .map(
                (e) => Chat(
                  id: e['id'],
                  userId: e['userId'],
                  userName: e['userName'],
                  text: e['text'],
                  date: DateTime.parse(e['date']),
                ),
              )
              .toList(),
        ),
      );
      setState('');
      Navigator.of(ctx).pop();
      notifyListeners();
    } catch (e) {
      setState('error');
    }
    return Future.value();
  }
}
