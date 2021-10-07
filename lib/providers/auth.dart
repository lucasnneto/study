import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/Http.dart';
import 'package:study/utils/Status.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Status status = Status();
  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) return _token;
    return null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> signup(Map<String, String> payload, BuildContext context) async {
    final dio = Http.signup_dio;
    try {
      setState('loading');
      final res = await dio.post('', data: {
        'email': payload['email'],
        'password': payload['senha'],
        'returnSecureToken': true,
      });
      _token = res.data['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(res.data['expiresIn'])));
      _userId = res.data['localId'];
      setState('');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Conta criada com sucesso!')));
      Navigator.of(context)
        ..pop()
        ..pushReplacementNamed(AppRoutes.HOME);
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
    if (type == 'loading')
      status.setLoading();
    else if (type == 'erro')
      status.setError();
    else
      status.setVoid();
    notifyListeners();
  }

  Future<void> signin(Map<String, String> payload, BuildContext context) async {
    final dio = Http.signin_dio;
    try {
      setState('loading');
      final res = await dio.post('', data: {
        'email': payload['email'],
        'password': payload['senha'],
        'returnSecureToken': true,
      });
      _token = res.data['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(res.data['expiresIn'])));
      _userId = res.data['localId'];
      setState('');
      Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro ao entrar na conta!')));
      setState('error');
    }

    notifyListeners();
    return Future.value();
  }
}
