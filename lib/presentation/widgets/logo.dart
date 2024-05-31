import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  const LogoWidget({this.size = 100, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size * 0.8,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Image.asset(
          "assets/images/logo.png",
          height: size,
        ),
      ),
    );
  }
}
