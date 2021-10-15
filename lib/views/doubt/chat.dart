import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/doubt.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/body.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/widget/tab_navigator.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatState();
}

class _ChatState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();
  List<Color> cores = [
    Colors.orange,
    Colors.pink,
    Colors.black,
    Colors.lime,
    Colors.purple,
  ];

  TextEditingController msg = TextEditingController();

  bool _needScroll = true;

  _scrollToEnd() async {
    if (_needScroll) {
      _needScroll = false;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  bool load = false;
  bool load2 = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToEnd());
    Random rand = new Random();
    final index = ModalRoute.of(context)!.settings.arguments as int;
    final doubts = Provider.of<Doubts>(context);
    final doubt = doubts.items[index];
    final usersColors = {};
    doubt.chat.forEach((e) {
      usersColors[e.userId] = cores[rand.nextInt(cores.length)];
    });
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final userName = Provider.of<Auth>(context, listen: false).userName;
    final mediaQuery = MediaQuery.of(context);

    send() async {
      if (msg.text.isEmpty) return;
      final payload = {
        "text": msg.text,
        "userId": userId,
        "userName": userName,
        "doubtId": doubt.id,
      };
      await doubts.addChat(payload, context);
      msg.clear();
    }

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Auth auth = Provider.of<Auth>(context);
          if (!auth.isAuth) Navigator.of(context).pop();
          // retorna um objeto do tipo Dialog
          final status = doubt.status;
          final value = status == 'open' ? 'finalizado' : 'aberto';
          return StatefulBuilder(builder: (context, setS) {
            return AlertDialog(
              title: Text("Alterar Status do problema"),
              content: Text(
                "Alterar problema para $value",
                style: TextStyle(
                  color: status == 'open'
                      ? Colors_Theme.success
                      : Colors_Theme.warning,
                ),
              ),
              actions: [
                // define os botões na base do dialogo
                TextButton(
                  child: Text("Fechar"),
                  style: TextButton.styleFrom(primary: Colors_Theme.error),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: load2
                      ? Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(),
                        )
                      : Text("Salvar"),
                  onPressed: () async {
                    final payload = {
                      "value": status == 'open' ? 'finish' : 'open',
                      "doubtId": doubt.id,
                    };
                    setS(() {
                      load2 = true;
                    });
                    await doubts.changeStatus(payload, context);
                    setS(() {
                      load2 = false;
                    });
                  },
                ),
              ],
            );
          });
        },
      );
    }

    return Body(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    mini: true,
                    elevation: 1,
                    // backgroundColor: Colors.transparent,
                    shape: CircleBorder(),
                    onPressed: () {
                      TabNavigator.of(context).pop(context);
                    },
                    child: Icon(Icons.chevron_left),
                  ),
                  Text(
                    doubt.userName,
                    style: TextStyle(
                      color: Colors_Theme.blue_Theme[700],
                      fontSize: 27,
                    ),
                  ),
                  load
                      ? Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(),
                        )
                      : FloatingActionButton(
                          mini: true,
                          elevation: 1,
                          // backgroundColor: Colors.transparent,
                          shape: CircleBorder(),
                          onPressed: () async {
                            setState(() {
                              load = true;
                            });
                            await Provider.of<Doubts>(context, listen: false)
                                .loadDoubts();
                            setState(() {
                              load = false;
                            });
                          },
                          child: Icon(Icons.refresh_outlined),
                        )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    doubt.title,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  doubt.status == 'open'
                      ? GestureDetector(
                          onTap: doubt.userId == userId ? _showDialog : null,
                          child: Icon(
                            Icons.help_outline_outlined,
                            color: Colors_Theme.warning,
                          ),
                        )
                      : GestureDetector(
                          onTap: doubt.userId == userId ? _showDialog : null,
                          child: Icon(
                            Icons.check_circle_outline_outlined,
                            color: Colors_Theme.success,
                          ),
                        ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 340 - MediaQuery.of(context).viewInsets.bottom * 0.7,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      ...doubt.chat
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  alignment: e.userId == userId
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            e.userId == userId ? 10 : 0),
                                        bottomRight: Radius.circular(
                                            e.userId == userId ? 0 : 10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      color: Colors_Theme.blue_Theme[
                                          e.userId == userId ? 200 : 300],
                                    ),
                                    width: mediaQuery.size.width * 0.5,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        e.userId != userId
                                            ? Text(
                                                e.userName,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        usersColors[e.userId]),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                            height:
                                                e.userId != userId ? 10 : 0),
                                        Text(
                                          e.text,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: mediaQuery.size.width - 100,
                    child: s_textfield(
                      onTap: () {
                        _needScroll = true;
                        _scrollToEnd();
                      },
                      submited: send,
                      label: "Mensagem",
                      editingController: msg,
                    )),
                doubts.status != 'loading'
                    ? FloatingActionButton(
                        // backgroundColor: Colors.transparent,
                        shape: CircleBorder(),
                        elevation: 1,
                        onPressed: send,
                        child: Icon(
                          Icons.send,
                          size: 30,
                        ),
                      )
                    : Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(),
                      ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
