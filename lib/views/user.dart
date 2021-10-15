import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/providers/auth.dart';
import 'package:study/utils/colors.dart';

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
    modalDelete() {
      showDialog(
          context: context,
          builder: (ctx) {
            return StatefulBuilder(builder: (c, setS) {
              Auth auth = Provider.of<Auth>(c);
              if (!auth.isAuth) Navigator.of(c).pop();
              return AlertDialog(
                title: Text("Apagar dados?",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text(
                    "Você tem certeza que deseja apagar todo seu progresso de aprendizado e exercícios feitos?"),
                actions: [
                  TextButton(
                    child: Text("Fechar"),
                    style:
                        TextButton.styleFrom(primary: Colors_Theme.blue_Theme),
                    onPressed: () {
                      Navigator.of(c).pop();
                    },
                  ),
                  TextButton(
                    child: load
                        ? Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                                color: Colors.red))
                        : Text("Apagar"),
                    style: TextButton.styleFrom(primary: Colors_Theme.error),
                    onPressed: load
                        ? null
                        : () async {
                            setS(() {
                              load = true;
                            });
                            await auth.removeStatus(auth.userId!, context);
                            setS(() {
                              load = false;
                            });
                            Navigator.of(c).pop();
                          },
                  ),
                ],
              );
            });
          });
    }

    modalExit() {
      showDialog(
          context: context,
          builder: (ctx) {
            return StatefulBuilder(builder: (c, setS) {
              Auth auth = Provider.of<Auth>(c);
              if (!auth.isAuth) Navigator.of(c).pop();
              return AlertDialog(
                title: Text("Tem certeza que deseja sair?",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                actions: [
                  TextButton(
                    child: Text("Fechar"),
                    style:
                        TextButton.styleFrom(primary: Colors_Theme.blue_Theme),
                    onPressed: () {
                      Navigator.of(c).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Sair"),
                    style: TextButton.styleFrom(primary: Colors_Theme.error),
                    onPressed: () async {
                      auth.logout();
                      Navigator.of(c).pop();
                    },
                  ),
                ],
              );
            });
          });
    }

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
        ElevatedButton(
          onPressed: modalDelete,
          child: Text("Limpar Dados", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            primary: Colors_Theme.error,
            minimumSize: Size(250, 52),
            shape: StadiumBorder(),
          ),
        ),
        s_button(
          function: modalExit,
          label: "Sair",
        ),
      ],
    );
  }
}
