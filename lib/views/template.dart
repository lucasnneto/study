import 'package:flutter/material.dart';
import 'package:study/utils/colors.dart';
import 'package:study/views/doubt.dart';
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
  int _selectedScreenIndex = 0;
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        unselectedItemColor: Colors_Theme.blue_Theme[50],
        selectedItemColor: Colors_Theme.blue_Theme[700],
        currentIndex: _selectedScreenIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: "Config"),
        ],
      ),
    );
    ;
  }
}
