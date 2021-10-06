import 'package:flutter/material.dart';
import 'package:study/components/s_button.dart';
import 'package:study/utils/colors.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/login.png',
                            width: mediaQuery.size.width * 0.6,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              label: Text('Email',
                                  style: TextStyle(
                                    color: Colors_Theme.blue_Theme[700],
                                  )),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.transparent),
                                borderRadius: new BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors_Theme.blue_Theme[50],
                            ),
                          )
                        ]),
                    height: mediaQuery.size.height * 0.5,
                    width: mediaQuery.size.width * 0.7,
                    constraints: BoxConstraints(maxWidth: 320, maxHeight: 420),
                  ),
                ),
                s_button(
                  function: () {},
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
      ]),
    );
  }
}
