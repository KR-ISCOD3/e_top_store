import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../cart/cart_screen.dart';
import '../favourite/favourite_screen.dart';
import '../profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  /// 🔹 Switch to Cart tab
  void openCart() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
          onOpenCart: openCart, // ✅ PASS CALLBACK
        );

      case 1:
        return const ExploreScreen();

      case 2:
        return CartScreen(
          onBack: () {
            setState(() {
              _selectedIndex = 0; // ✅ back to Home
            });
          },
        );

      case 3:
        return FavouriteScreen(
          onBack: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        );

      case 4:
        return const ProfileScreen();

      default:
        return HomeScreen(onOpenCart: openCart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
