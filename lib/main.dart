import 'package:flutter/material.dart';
import 'screens/explore_screen.dart'; 

void main() {
  runApp(const MyApp());
}

/// Root app widget - open ExploreScreen directly.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: ExploreScreen(),
    );
  }
}