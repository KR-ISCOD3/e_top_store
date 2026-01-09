import 'package:e_top_store/data/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../cart/cart_screen.dart';
import '../favourite/favourite_screen.dart';
import '../profile/profile_screen.dart';

import '../auth/login_screen.dart';
import '../profile/guest_account_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  void openCart() {
    setState(() => _selectedIndex = 2);
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen(onOpenCart: openCart);
      case 1:
        return ExploreScreen(onOpenCart: openCart);
      case 2:
        return CartScreen(onBack: () => setState(() => _selectedIndex = 0));
      case 3:
        return FavouriteScreen(
            onBack: () => setState(() => _selectedIndex = 0));
      case 4:
        return AuthService.isLoggedIn
            ? const ProfileScreen()
            : const GuestAccountScreen();
      default:
        return HomeScreen(onOpenCart: openCart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return SafeArea(
      top: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_outlined, Icons.home, 'Home'),
            _navItem(1, Icons.explore_outlined, Icons.explore, 'Explore'),
            _navItem(2, Icons.shopping_cart_outlined,
                Icons.shopping_cart, 'Cart'),
            _navItem(3, Icons.favorite_border, Icons.favorite, 'Favorite'),
            _navItem(4, Icons.person_outline, Icons.person, 'Account'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () async {
        if (index == 4 && !AuthService.isLoggedIn) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
          setState(() {});
          return;
        }
        setState(() => _selectedIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                size: 22,
                color: isActive ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
