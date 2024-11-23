import 'package:flutter/material.dart';

// Placeholder Screens for Admin Tabs
class AssistPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Assist Post Screen"));
  }
}

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Users Screen"));
  }
}

class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Analysis Screen"));
  }
}

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Reports Screen"));
  }
}

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Messages Screen"));
  }
}

// Admin Screen with Bottom Navigation Bar
class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0; // Default to the "Assist Post" tab

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    AssistPostPage(),
    UsersPage(),
    AnalysisPage(),
    ReportsPage(),
    MessagesPage(),
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
            icon: Icon(Icons.post_add),
            label: 'Assist Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: AdminScreen(),
  ));
}
