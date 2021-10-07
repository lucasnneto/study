import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/providers/auth.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/auth/login.dart';
import 'package:study/views/auth/registre.dart';
import 'package:study/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
      ],
      child: MaterialApp(
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
          AppRoutes.REGISTRE: (ctx) => Registre(),
          AppRoutes.HOME: (ctx) => Home(),
        },
      ),
    );
  }
}
