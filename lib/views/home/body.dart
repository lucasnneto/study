import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study/components/s_tabs.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return s_tabs(
        tabs: [
          s_Tab(text: "AULAS", value: 1),
          s_Tab(text: "ATIVIDADES", value: 2)
        ],
        update: (value) {
          print(value);
        });
  }
}
