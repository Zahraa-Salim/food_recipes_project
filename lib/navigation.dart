import 'package:flutter/material.dart';
import 'package:food_recipes_project/home_page.dart';
import 'package:food_recipes_project/favorite_page.dart';
import 'package:food_recipes_project/search_page.dart';
import 'package:food_recipes_project/account_page.dart';

class Navigation extends StatefulWidget {
  final int initialIndex;

  // Constructor to accept an initial selected index
  const Navigation({super.key, this.initialIndex = 0});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late int _currentIndex;

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    const SearchPage(),
    const FavoritePage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the current index with the passed parameter
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFFD6A00), // Active icon color
        unselectedItemColor: Colors.grey, // Inactive icon color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
