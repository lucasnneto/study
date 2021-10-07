import 'package:flutter/cupertino.dart';

class Status {
  String status = "";

  Status({this.status = ''});

  bool get isVoid {
    return status == '';
  }

  bool get isLoading {
    return status == 'loading';
  }

  bool get isError {
    return status == 'error';
  }

  void setVoid() {
    status = '';
  }

  void setLoading() {
    status = 'loading';
  }

  void setError() {
    status = 'error';
  }
}
