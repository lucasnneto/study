import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/providers/auth.dart';
import 'package:study/views/auth/login.dart';
import 'package:study/views/template.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? Template() : Login();
        }
      },
    );
  }
}
