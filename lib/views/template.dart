import 'package:flutter/material.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/doubt/index.dart';
import 'package:study/views/home.dart';
import 'package:study/views/user.dart';

class Template extends StatefulWidget {
  const Template({
    Key? key,
  }) : super(key: key);

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  int _selectedScreenIndex = 1;
  final List<Widget> _screens = [
    Home(),
    Doubt(),
    User(),
  ];
  _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
    ;
  }
}
