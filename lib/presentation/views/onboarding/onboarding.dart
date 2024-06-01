import 'package:flutter/material.dart';
import 'package:prep_for_dev/core/utils/app_helpers.dart';
import 'package:prep_for_dev/themes/app_theme.dart';

import '../../../core/utils/preferences.dart';
import '../../widgets/simple_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [AppTheme.primaryColor.withOpacity(0.3), Colors.white],
                stops: const [0.0, 0.4],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Prep4Dev 〽️",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
            AppHelpers.getSpacerHeight(1),
            Image.asset("assets/images/interview.png"),
            const Text("Springboard to Interview Success",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            AppHelpers.getSpacerHeight(1),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Prepare for developer interviews with our carefully selected questions and answers from Gemini AI.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            AppHelpers.getSpacerHeight(2),
            SimpleButton(
              color: AppTheme.primaryColor,
              textColor: Colors.white,
              text: 'Get Started',
              onPressed: () {
                SharedPreferencesHelper.setIntValue("is_not_first", 1);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
