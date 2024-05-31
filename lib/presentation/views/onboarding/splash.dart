import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prep_for_dev/presentation/widgets/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacementNamed(context, "/on-boarding");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/splash_bg.png"),
                fit: BoxFit.cover)),
        alignment: Alignment.center,
        child: const LogoWidget(size: 90),
      ),
    );
  }
}
