import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  TabNavigator(
      {required this.navigatorKey, required this.routeBuilders, this.initial});
  final GlobalKey<NavigatorState>? navigatorKey;
  final Map<String, WidgetBuilder> routeBuilders;
  final String? initial;

  Future<void> push(BuildContext context, String router,
      {Object? arguments}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[router]!(context),
        settings: RouteSettings(arguments: arguments),
      ),
    );
    return Future.value();
  }

  void pop(BuildContext context) {
    Navigator.pop(context);
  }

  Future<bool> maybePop(BuildContext context) async {
    return await Navigator.maybePop(context);
  }

  static TabNavigator of(BuildContext context) {
    TabNavigator? navigator;
    if (context is StatelessWidget && context is TabNavigator) {
      navigator = context as TabNavigator;
    }
    navigator =
        navigator ?? context.findAncestorWidgetOfExactType<TabNavigator>();

    return navigator!;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initial,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
