import 'package:flutter/material.dart';
import 'screens/payment_methods_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root app widget - open PaymentMethodsScreen directly.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentMethodsScreen(),
    );
  }
}