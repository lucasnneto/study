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
  static Chat toClass(Map<String, dynamic?> item) {
    return Chat(
      id: item['id'],
      userId: item['userId'],
      userName: item['userName'],
      text: item['text'],
      date: DateTime.parse(
        item['date'],
      ),
    );
  }
}

class Doubt {
  final String id;
  final String userId;
  final String userName;
  final String title;
  String status;
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
  static Doubt toClass(Map<String, dynamic?> doubtData, String doubtId) {
    return Doubt(
      id: doubtId,
      userId: doubtData['userId'],
      userName: doubtData['userName'],
      title: doubtData['title'],
      status: doubtData['status'],
      date: DateTime.parse(doubtData['date']),
      chat: (doubtData['chat'] as List<dynamic>)
          .map((e) => Chat.toClass(e))
          .toList(),
    );
  }
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
          loadedItems.add(Doubt.toClass(doubtData, doubtId));
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

  Future<void> changeStatus(
      Map<String, String?> payload, BuildContext ctx) async {
    final dio = Http.dio;
    final id = payload['doubtId'];
    final index = _items.indexWhere((el) => el.id == id);
    if (index != -1) {
      try {
        final res = await dio.patch(
          '/doubt/$id/.json',
          data: {"status": payload['value']},
        );
        print(res.data);
        _items[index].status = payload['value']!;
        Navigator.of(ctx).pop();
      } catch (e) {
        setState('error');
      }
    }
    notifyListeners();
    return Future.value();
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

  Future<void> addChat(Map<String, String?> payload, BuildContext ctx) async {
    setState('loading');
    final dio = Http.dio;
    final date = DateTime.now();
    final uuid = Uuid().v4();
    final idDoubt = payload['doubtId'];
    final index = _items.indexWhere((el) => el.id == payload['doubtId']);
    if (index != -1) {
      final chats = _items[index]
          .chat
          .map((e) => {
                "id": e.id,
                "userId": e.userId,
                "userName": e.userName,
                "text": e.text,
                "date": e.date.toIso8601String(),
              })
          .toList();
      Map<String, String> chat = {
        "id": uuid,
        "userId": payload['userId']!,
        "userName": payload['userName']!,
        "text": payload['text']!,
        "date": date.toIso8601String(),
      };
      chats.add(chat);

      try {
        final res = await dio.put(
          '/doubt/$idDoubt/chat.json',
          data: chats,
        );
        _items[index].chat.add(Chat(
              id: chat['id']!,
              userId: chat['userId']!,
              userName: chat['userName']!,
              text: chat['text']!,
              date: DateTime.parse(chat['date']!),
            ));
        setState('');
        notifyListeners();
      } catch (e) {
        setState('error');
      }
    }
    return Future.value();
  }
}
