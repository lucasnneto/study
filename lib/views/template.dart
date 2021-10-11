import 'package:flutter/material.dart';
import 'package:study/utils/App_routes.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/doubt/index.dart';
import 'package:study/views/doubt/new_doubt.dart';
import 'package:study/views/doubt/chat.dart';
import 'package:study/views/home.dart';
import 'package:study/views/user.dart';
import 'package:study/widget/tab_navigator.dart';

class Template extends StatefulWidget {
  const Template({
    Key? key,
  }) : super(key: key);

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  int _selectedScreenIndex = 0;
  final List<TabNavigator> _screens = [
    TabNavigator(
      navigatorKey: GlobalKey<NavigatorState>(),
      routeBuilders: {
        Routes_Main.HOME: (context) => Home(),
      },
      initial: Routes_Main.HOME,
    ),
    TabNavigator(
      navigatorKey: GlobalKey<NavigatorState>(),
      routeBuilders: {
        Routes_Doubt.HOME: (context) => Doubt(),
        Routes_Doubt.NEW: (context) => newDoubt(),
        Routes_Doubt.DETAIL: (context) => Chat(),
      },
      initial: Routes_Doubt.HOME,
    ),
    TabNavigator(
      navigatorKey: GlobalKey<NavigatorState>(),
      routeBuilders: {
        Routes_User.HOME: (context) => User(),
      },
      initial: Routes_User.HOME,
    ),
  ];
  _selectScreen(int index) {
    if (index == _selectedScreenIndex) {
      // pop to first route
      _screens[_selectedScreenIndex]
          .navigatorKey!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedScreenIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await _screens[_selectedScreenIndex]
            .navigatorKey!
            .currentState!
            .maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_selectedScreenIndex != 0) {
            _selectScreen(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            child: _screens[_selectedScreenIndex],
          ),
        ),
        bottomNavigationBar: Container(
          height: 72,
          child: Column(
            children: [
              Divider(
                color: Colors_Theme.blue_Theme[700],
              ),
              BottomNavigationBar(
                onTap: _selectScreen,
                elevation: 0,
                unselectedItemColor: Colors_Theme.blue_Theme[50],
                selectedItemColor: Colors_Theme.blue_Theme[700],
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: _selectedScreenIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people_alt_outlined), label: "Config"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
