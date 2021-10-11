import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/providers/auth.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/template.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  bool load = false;
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    TextEditingController name = TextEditingController(text: auth.userName);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.person_outlined,
          size: 70,
        ),
        Container(
          width: 260,
          child: s_textfield(
            label: "Nome",
            editingController: name,
            readOnly: true,
          ),
        ),
        load
            ? Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () async {
                  setState(() {
                    load = true;
                  });
                  await auth.removeStatus(auth.userId!, context);
                  setState(() {
                    load = false;
                  });
                },
                child:
                    Text("Limpar Dados", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Colors_Theme.error,
                  minimumSize: Size(250, 52),
                  shape: StadiumBorder(),
                ),
              ),
        s_button(
          function: () {
            auth.logout();
          },
          label: "Sair",
        ),
      ],
    );
  }
}
