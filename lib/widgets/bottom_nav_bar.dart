import 'package:diary_app/screens/add_memory_screen.dart';
import 'package:diary_app/screens/home_screen.dart';
import 'package:diary_app/screens/page_scroll_screen.dart';
import 'package:diary_app/screens/search_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  static const routeName = '/nav-bar';
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screen = [
      const HomeScreen(),
      const PageScrollScreen(),
      AddPlaceScreen(),
      SearchScreen(),
    ];
    return Scaffold(
      body: screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: "",
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_day_outlined),
            label: "",
            backgroundColor: Color.fromARGB(255, 75, 136, 196),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_photo_alternate_outlined),
            label: "",
            backgroundColor: Color.fromARGB(255, 242, 95, 93),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
            backgroundColor: Color.fromARGB(255, 255, 187, 0),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
