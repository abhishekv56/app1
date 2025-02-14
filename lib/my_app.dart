import 'package:assignment2/Login/login_screen.dart';
import 'package:assignment2/splash_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:WelcomeScreen()
    );
  }
}

