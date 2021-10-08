import 'package:flutter/material.dart';

class Constants {
  static const BASE_API_URL =
      "https://meu-tcc-cfd93-default-rtdb.firebaseio.com/";
  static const AUTH_URL = "https://identitytoolkit.googleapis.com/v1/accounts:";
  static const KEY_LOGIN = "?key=AIzaSyBKHK8CNMg0fxES9DYipn4BTxb-2VVieHU";
  static const typeKeyboard = {
    'text': TextInputType.text,
    'password': TextInputType.text,
    'number': TextInputType.number,
    'email': TextInputType.emailAddress
  };
}
