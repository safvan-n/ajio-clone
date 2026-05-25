import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/ajio_theme.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';
import 'bag_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const WishlistScreen(),
    const BagScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final currentIndex = store.currentTabIndex;
    final cartCount = store.cart.fold<int>(0, (sum, item) => sum + item.quantity);
    final wishlistCount = store.wishlist.length;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => store.setTabIndex(index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: wishlistCount > 0,
              label: Text(
                wishlistCount.toString(),
                style: const TextStyle(fontSize: 9, color: Colors.white),
              ),
              backgroundColor: AjioTheme.ajioGold,
              child: const Icon(Icons.favorite_border),
            ),
            activeIcon: Badge(
              isLabelVisible: wishlistCount > 0,
              label: Text(
                wishlistCount.toString(),
                style: const TextStyle(fontSize: 9, color: Colors.white),
              ),
              backgroundColor: AjioTheme.ajioGold,
              child: const Icon(Icons.favorite),
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(
                cartCount.toString(),
                style: const TextStyle(fontSize: 9, color: Colors.white),
              ),
              backgroundColor: AjioTheme.discountRed,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(
                cartCount.toString(),
                style: const TextStyle(fontSize: 9, color: Colors.white),
              ),
              backgroundColor: AjioTheme.discountRed,
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Bag',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
