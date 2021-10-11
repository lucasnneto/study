import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:study/data/Store.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/Http.dart';
import 'package:study/utils/Status.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
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
      await dio.put('user.json', queryParameters: {
        'auth': _token,
      }, data: {
        _userId: {'name': payload['name'], 'progress': []}
      });
      _name = payload['name'];
      _progress = [];
      setState('');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Conta criada com sucesso!')));
      await Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
        "name": _name,
        "progress": _progress
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

  Future<void> tryAutoLogin() async {
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
      setState('loading');
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

      await Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
        "name": _name,
        "progress": _progress
      });
      _autoLogout();
      setState('');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro ao entrar na conta!')));
      setState('error');
    }

    notifyListeners();
    return Future.value();
  }
}
