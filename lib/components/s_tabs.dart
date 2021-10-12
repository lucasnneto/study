import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:study/utils/colors.dart';

class s_Tab {
  final dynamic value;
  final String text;
  s_Tab({
    required this.value,
    required this.text,
  });
}

class s_tabs extends StatelessWidget {
  final List<s_Tab> tabs;
  final Function(dynamic value) update;
  final dynamic selectedValue;

  const s_tabs(
      {Key? key,
      required this.tabs,
      required this.update,
      required this.selectedValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // update(selectedValue);

    return LayoutBuilder(builder: (ctx, contraints) {
      return Container(
        constraints: BoxConstraints(maxHeight: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...tabs
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      update(e.value);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: contraints.maxWidth * (1 / tabs.length),
                      child: Column(
                        children: [
                          Text(
                            e.text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: selectedValue == e.value
                                  ? Colors_Theme.blue_Theme[500]
                                  : Colors_Theme.blue_Theme[200],
                            ),
                          ),
                          selectedValue == e.value
                              ? Container(
                                  width:
                                      contraints.maxWidth * (1 / tabs.length),
                                  child: Divider(
                                    color: Colors_Theme.blue_Theme[500],
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        ),
      );
    });
  }
}
