import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prep_for_dev/presentation/routes/app_router.dart';
import 'package:prep_for_dev/themes/app_theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prep4Dev',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    );
  }
}
