import 'package:flutter/material.dart';
// import 'screens/explore_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/favourite_screen.dart';
import 'screens/payment_methods_screen.dart';

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
      // home: ExploreScreen(),
      // home: HomeScreen(),
      // home: FavouriteScreen(),
      home: PaymentMethodsScreen(),
    );
  }
}
