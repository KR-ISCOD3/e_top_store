import 'package:e_top_store/ui/screens/main/main_layout.dart';
import 'package:flutter/material.dart';

// ✅ ADD THIS (GLOBAL)
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ REGISTER OBSERVER HERE
      navigatorObservers: [routeObserver],

      home: const MainLayout(),
    );
  }
}
