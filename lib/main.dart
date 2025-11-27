import 'package:flutter/material.dart';
import 'screens/help_center_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root app widget - open Help Center directly for preview.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HelpCenterScreen(),
    );
  }
}
