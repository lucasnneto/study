import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study/providers/doubt.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/colors.dart';
import 'package:study/widget/tab_navigator.dart';

class Doubt extends StatelessWidget {
  const Doubt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text(
              'Alguma dúvida?',
              style: TextStyle(
                color: Colors_Theme.blue_Theme[700],
                fontSize: 27,
              ),
            ),
            FloatingActionButton(
              mini: true,
              onPressed: () {
                TabNavigator.of(context).push(context, Routes_Doubt.NEW);
              },
              child: Icon(Icons.add),
            )
          ],
        ),
        Container(
          height: mediaQuery.size.height - 72 - 96,
          child: FutureBuilder(
              future: Provider.of<Doubts>(context, listen: false).loadDoubts(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.error != null) {
                  return Center(child: Text('Ocorreu um erro!'));
                } else {
                  return Consumer<Doubts>(
                      builder: (ctx, doubts, child) => RefreshIndicator(
                            onRefresh: () =>
                                Provider.of<Doubts>(context, listen: false)
                                    .loadDoubts(),
                            child: ListView.builder(
                              itemCount: doubts.itemsCount,
                              itemBuilder: (ctx, i) => Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      TabNavigator.of(context).push(
                                        context,
                                        Routes_Doubt.DETAIL,
                                        arguments: i,
                                      );
                                    },
                                    title: Text(doubts.items[i].title),
                                    subtitle: Text(doubts.items[i].userName),
                                    trailing: Column(
                                      children: [
                                        doubts.items[i].status == 'open'
                                            ? Icon(
                                                Icons.help_outline_outlined,
                                                color: Colors_Theme.warning,
                                              )
                                            : Icon(
                                                Icons
                                                    .check_circle_outline_outlined,
                                                color: Colors_Theme.success,
                                              ),
                                        SizedBox(height: 5),
                                        Text(
                                            '${doubts.items[i].date.day}/${doubts.items[i].date.month}'),
                                      ],
                                    ),
                                  ),
                                  doubts.itemsCount > (i + 1)
                                      ? Divider(
                                          color: Colors_Theme.blue_Theme[700],
                                        )
                                      : SizedBox(height: 0),
                                ],
                              ),
                            ),
                          ));
                }
              }),
        )
      ],
    );
  }
}
