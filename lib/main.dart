import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const YuyuTubeApp());
}

class YuyuTubeApp extends StatelessWidget {
  const YuyuTubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YuyuTube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Constants.bgColor,
        colorScheme: const ColorScheme.dark(
          primary: Constants.primaryColor,
          surface: Constants.cardColor,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}