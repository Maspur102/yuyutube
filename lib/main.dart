import 'package:flutter/material.dart';
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
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}