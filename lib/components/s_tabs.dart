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

class s_tabs extends StatefulWidget {
  final List<s_Tab> tabs;
  final Function(dynamic value) update;

  const s_tabs({Key? key, required this.tabs, required this.update})
      : super(key: key);

  @override
  State<s_tabs> createState() => _s_tabsState();
}

class _s_tabsState extends State<s_tabs> {
  @override
  Widget build(BuildContext context) {
    dynamic selectedValue = widget.tabs[0].value;
    widget.update(selectedValue);
    return StatefulBuilder(builder: (context, setS) {
      return LayoutBuilder(builder: (context, contraints) {
        return Container(
          constraints: BoxConstraints(maxHeight: 200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...widget.tabs
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        setS(() {
                          widget.update(e.value);
                          selectedValue = e.value;
                        });
                      },
                      child: Container(
                        width: contraints.maxWidth * (1 / widget.tabs.length),
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
                                    width: contraints.maxWidth *
                                        (1 / widget.tabs.length),
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
    });
  }
}
