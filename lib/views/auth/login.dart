import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/providers/auth.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/rules.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final nodeEmail = FocusNode();
  final nodePass = FocusNode();
  final _form = GlobalKey<FormState>();
  login() async {
    setState(() {
      load = true;
    });
    Auth auth = Provider.of<Auth>(context, listen: false);
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    final payload = {
      'email': email.text,
      'senha': senha.text,
    };
    await auth.signin(payload, context);
    setState(() {
      load = false;
    });
  }

  bool load = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Auth auth = Provider.of<Auth>(context);

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/bg.png',
        ),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    color: Colors.transparent,
                    shadowColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                      child: Form(
                        key: _form,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/login.png',
                                width: mediaQuery.size.width * 0.6,
                              ),
                              s_textfield(
                                label: 'Email',
                                editingController: email,
                                type: 'email',
                                nextFocusNode: nodePass,
                                focusNode: nodeEmail,
                                rules: [Rules.required, Rules.email],
                              ),
                              s_textfield(
                                  label: 'Senha',
                                  editingController: senha,
                                  type: 'password',
                                  focusNode: nodePass,
                                  submited: login,
                                  rules: [Rules.required]),
                            ]),
                      ),
                      height: mediaQuery.size.height * 0.55,
                      width: mediaQuery.size.width * 0.8,
                      constraints:
                          BoxConstraints(maxWidth: 350, maxHeight: 440),
                    ),
                  ),
                  SizedBox(height: 25),
                  load
                      ? Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(),
                        )
                      : s_button(
                          function: login,
                          label: 'Entrar',
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não tem conta?'),
                      TextButton(
                          onPressed: !load
                              ? null
                              : () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.REGISTRE);
                                },
                          child: Text('Crie'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
