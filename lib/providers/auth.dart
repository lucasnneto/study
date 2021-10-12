import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/data/Store.dart';
import 'package:study/providers/language.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/Http.dart';
import 'package:study/utils/Status.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _language;
  String status = "";
  Timer? _logoutTimer;
  String? _name;
  List? _progress;
  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) return _token;
    return null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  String? get userName {
    return isAuth ? _name : null;
  }

  List? get progress {
    return isAuth ? _progress : null;
  }

  int get lengthProgress {
    return isAuth && _progress != null ? _progress!.length : 0;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> signup(Map<String, String> payload, BuildContext context) async {
    final signdio = Http.signup_dio;
    final dio = Http.dio;
    try {
      setState('loading');
      final res = await signdio.post('', data: {
        'email': payload['email'],
        'password': payload['senha'],
        'returnSecureToken': true,
      });
      _token = res.data['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(res.data['expiresIn'])));
      _userId = res.data['localId'];
      await dio.put('user/$_userId.json', queryParameters: {
        'auth': _token,
      }, data: {
        'name': payload['name'],
        'progress': [],
        'language': 'java' //TODO PARA ESCOLHER LINGUAGEM
      });
      _name = payload['name'];
      _progress = [];
      _language = "java"; //TODO PARA ESCOLHER LINGUAGEM
      await Provider.of<Language>(context, listen: false)
          .loadLanguage(_language!);
      setState('');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Conta criada com sucesso!')));
      await Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
        "name": _name,
        "progress": _progress,
        "language": _language
      });
      _autoLogout();
      Navigator.of(context).pop();
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro ao criar a conta!')));
      setState('error');
    }

    notifyListeners();
    return Future.value();
  }

  void setState(type) {
    status = type;

    notifyListeners();
  }

  Future<void> tryAutoLogin(context) async {
    if (isAuth) return Future.value();
    final userData = await Store.getMap('userData');
    if (userData == null) return Future.value();
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return Future.value();
    _token = userData['token'];
    _expiryDate = expiryDate;
    _userId = userData['userId'];
    _name = userData['name'];
    _progress = userData['progress'];
    _language = userData['language'];
    await Provider.of<Language>(context, listen: false)
        .loadLanguage(_language!);

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout!), logout);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  Future<void> signin(Map<String, String> payload, BuildContext context) async {
    final diosign = Http.signin_dio;
    final dio = Http.dio;
    try {
      final res = await diosign.post('', data: {
        'email': payload['email'],
        'password': payload['senha'],
        'returnSecureToken': true,
      });
      _token = res.data['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(res.data['expiresIn'])));
      _userId = res.data['localId'];
      final resData = await dio.get('/user/$_userId.json');
      _name = resData.data['name'];
      _progress = resData.data['progress'];
      _language = resData.data['language'];
      await Provider.of<Language>(context, listen: false)
          .loadLanguage(_language!);

      await Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
        "name": _name,
        "progress": _progress,
        'language': _language
      });
      _autoLogout();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro ao entrar na conta!')));
      setState('error');
    }

    notifyListeners();
    return Future.value();
  }

  Future<void> removeStatus(String id, BuildContext context) async {
    final dio = Http.dio;
    try {
      await dio.delete('/user/$id/status.json');
      _progress = [];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Deletado com sucesso!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro ao apagar os dados!')));
    }
    return Future.value();
  }
}
