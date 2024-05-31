import 'package:flutter/material.dart';
import 'package:prep_for_dev/core/utils/app_helpers.dart';

class LoadingPage extends StatelessWidget {
  final String text;
  const LoadingPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: Stack(alignment: Alignment.center, children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/images/ai_robot.png",
              width: 80,
            ),
            AppHelpers.getSpacerHeight(4),
            Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.black54),
            ),
          ]),
          const Positioned(bottom: 0, child: CircularProgressIndicator())
        ]));
  }
}
