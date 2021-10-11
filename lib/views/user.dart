import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/providers/auth.dart';
import 'package:study/views/template.dart';

class User extends StatelessWidget {
  const User({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    return ElevatedButton(
      onPressed: () {
        auth.logout();
      },
      child: Text('Sair'),
    );
  }
}
