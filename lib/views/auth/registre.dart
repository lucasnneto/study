import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/providers/auth.dart';
import 'package:study/utils/colors.dart';
import 'package:study/utils/rules.dart';

class Registre extends StatefulWidget {
  const Registre({Key? key}) : super(key: key);

  @override
  State<Registre> createState() => _RegistreState();
}

class _RegistreState extends State<Registre> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final name = TextEditingController();
  final nodeEmail = FocusNode();
  final nodePass = FocusNode();
  final nodeName = FocusNode();
  final _form = GlobalKey<FormState>();

  registre() async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    final payload = {
      'email': email.text,
      'senha': senha.text,
      'name': name.text
    };
    await auth.signup(payload, context);
  }

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
                              Text(
                                'Começe a aprender',
                                style: TextStyle(
                                  color: Colors_Theme.blue_Theme[700],
                                  fontSize: 27,
                                ),
                              ),
                              s_textfield(
                                label: 'Nome',
                                editingController: name,
                                nextFocusNode: nodeEmail,
                                focusNode: nodeName,
                                rules: [Rules.required],
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
                                submited: registre,
                                rules: [Rules.required, Rules.min],
                              ),
                            ]),
                      ),
                      height: mediaQuery.size.height * 0.55,
                      width: mediaQuery.size.width * 0.8,
                      constraints:
                          BoxConstraints(maxWidth: 350, maxHeight: 440),
                    ),
                  ),
                  SizedBox(height: 25),
                  auth.status.isLoading
                      ? Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(),
                        )
                      : s_button(
                          function: registre,
                          label: 'Criar conta',
                        ),
                  TextButton(
                      onPressed: auth.status.isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: Text('Voltar'))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
