import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/doubt.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/body.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/widget/tab_navigator.dart';

class Chat extends StatelessWidget {
  Chat({Key? key}) : super(key: key);
  ScrollController _scrollController = ScrollController();
  TextEditingController msg = TextEditingController();
  bool _needScroll = true;
  _scrollToEnd() async {
    if (_needScroll) {
      _needScroll = false;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToEnd());

    final index = ModalRoute.of(context)!.settings.arguments as int;
    final doubts = Provider.of<Doubts>(context);
    final doubt = doubts.items[index];
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
                  doubt.status == 'open'
                      ? Icon(
                          Icons.help_outline_outlined,
                          color: Colors_Theme.warning,
                        )
                      : Icon(
                          Icons.check_circle_outline_outlined,
                          color: Colors_Theme.success,
                        ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                doubt.title,
                style: TextStyle(
                  fontSize: 20,
                ),
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
                                                style: TextStyle(fontSize: 10),
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
