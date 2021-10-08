import 'package:dio/dio.dart';
import 'package:study/utils/Constants.dart';

class Http {
  static final signup_dio = Dio(
    BaseOptions(
      baseUrl: '${Constants.AUTH_URL}signUp${Constants.KEY_LOGIN}',
    ),
  );
  static final signin_dio = Dio(
    BaseOptions(
      baseUrl: '${Constants.AUTH_URL}signInWithPassword${Constants.KEY_LOGIN}',
    ),
  );
  static final dio = Dio(
    BaseOptions(
      baseUrl: '${Constants.BASE_API_URL}',
    ),
  );
}
