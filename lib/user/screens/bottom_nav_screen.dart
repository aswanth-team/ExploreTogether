import 'package:flutter/material.dart';
import 'post_screen.dart';     // Import PostPage
import 'search_screen.dart';  // Import SearchPage
import 'home_screen.dart';    // Import HomePage
import 'chat_screen.dart';    // Import ChatPage
import 'profile_screen.dart'; // Import ProfilePage

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 2; // Default to the Home tab

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    PostPage(),
    SearchPage(),
    HomePage(),
    ChatPage(),
    ProfilePage(),
  ];

  // Function to switch between tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
