import 'package:flutter/material.dart';
import 'package:study/components/s_button.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/utils/colors.dart';
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
  login() {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    final payload = {email: email.text, senha: senha.text};
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

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
                  s_button(
                    function: login,
                    label: 'Entrar',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não tem conta?'),
                      TextButton(onPressed: () {}, child: Text('Crie'))
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
