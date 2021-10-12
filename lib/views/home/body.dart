import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/components/s_tabs.dart';
import 'package:study/providers/auth.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/home/lesson.dart';
import 'package:study/widget/tab_navigator.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    String capitalize(String? value) {
      if (value == null) return "";
      return value[0].toUpperCase() + value.substring(1);
    }

    List<Widget> screen = [
      LessonList(),
      Text('atividade'),
    ];
    int tab = 0;

    return StatefulBuilder(builder: (context, setState) {
      return Column(
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
                capitalize(auth.language),
                style: TextStyle(
                  color: Colors_Theme.blue_Theme[700],
                  fontSize: 27,
                ),
              ),
              SizedBox()
            ],
          ),
          s_tabs(
              tabs: [
                s_Tab(text: "AULAS", value: 0),
                s_Tab(text: "ATIVIDADES", value: 1)
              ],
              selectedValue: tab,
              update: (value) {
                setState(() {
                  tab = value;
                });
              }),
          screen[tab]
        ],
      );
    });
  }
}
