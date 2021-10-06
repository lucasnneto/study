import 'package:flutter/material.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/auth/login.dart';
import 'package:study/views/template.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors_Theme.blue_Theme,
          accentColor: Colors_Theme.blue_Theme[700],
          errorColor: Colors_Theme.error,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.AUTH_HOME: (ctx) => Login(),
      },
    );
  }
}
