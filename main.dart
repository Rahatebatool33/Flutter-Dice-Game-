
import 'package:flutter/material.dart';
import 'package:mypracticeapp/gradient_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GradientContainer(
        color1: Color(0xFF0F172A), // Midnight Indigo
        color2: Color(0xFF1E293B), // Deep Blue-Gray
      ),
    );
  }
}
