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

  // ✅ Initialize immediately (NO late)
  late final List<Widget> _pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const CartScreen(),

    FavouriteScreen(
      onBack: () {
        // this will be replaced safely later
      },
    ),

    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // ✅ Replace FavouriteScreen with correct callback
    _pages[3] = FavouriteScreen(
      onBack: () {
        setState(() {
          _selectedIndex = 0; // back to Home tab
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
