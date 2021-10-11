import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_button.dart';
import 'package:study/providers/auth.dart';
import 'package:study/providers/doubt.dart';
import 'package:study/utils/Rules.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/body.dart';
import 'package:study/components/s_textfield.dart';
import 'package:study/widget/tab_navigator.dart';

class Chat extends StatelessWidget {
  Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final doubt = ModalRoute.of(context)!.settings.arguments as Doubt;

    return Body(
        child: Column(
      children: [
        Text(doubt.title),
        ...doubt.chat.map((e) => Text(e.text)).toList(),
      ],
    ));
  }
}
