import 'package:flutter/material.dart';

class Template extends StatelessWidget {
  final Widget child;
  const Template({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          child: child,
        ),
      ),
    );
    ;
  }
}
