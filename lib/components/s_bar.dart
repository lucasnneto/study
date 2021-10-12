import 'package:flutter/material.dart';
import 'package:study/utils/colors.dart';

class s_bar extends StatelessWidget {
  final String label;
  final double percentege;
  s_bar({
    required this.label,
    required this.percentege,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: constraints.maxHeight * 0.05),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(label),
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              width: constraints.maxWidth,
              height: 30,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors_Theme.blue_Theme[50],
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentege,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors_Theme.blue_Theme[500],
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              width: constraints.maxWidth,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor:
                    percentege <= 0.05 ? percentege + 0.05 : percentege,
                alignment: Alignment.bottomRight,
                child: Text(
                  '${(percentege * 100).toStringAsFixed(1)}%',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors_Theme.blue_Theme[700], fontSize: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
